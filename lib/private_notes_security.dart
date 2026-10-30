import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Protects private-note content with a random AES-256-GCM master key.
/// The master key is wrapped separately by a PIN-derived key and a
/// recovery-code-derived key. The master key is only cached in memory while
/// the private-note area is unlocked.
class PrivateNotesSecurity {
  PrivateNotesSecurity._();
  static final PrivateNotesSecurity instance = PrivateNotesSecurity._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final AesGcm _aes = AesGcm.with256bits();
  static final Pbkdf2 _kdf = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 210000,
    bits: 256,
  );
  static const String _prefix = 'hiikaa_private_v1_';
  List<int>? _masterKey;

  bool get isUnlocked => _masterKey != null;

  Future<bool> get isConfigured async =>
      await _storage.read(key: '${_prefix}configured') == '1';

  Future<String> setup(String pin) async {
    _validatePin(pin);
    if (await isConfigured) {
      throw StateError('Private notes are already configured.');
    }

    final random = Random.secure();
    final master = List<int>.generate(32, (_) => random.nextInt(256));
    final pinSalt = _randomBytes(random, 16);
    final recoverySalt = _randomBytes(random, 16);
    final recoveryCode = _makeRecoveryCode(random);
    final pinKey = await _derive(pin, pinSalt);
    final recoveryKey = await _derive(_normalizeRecovery(recoveryCode), recoverySalt);
    final pinBox = await _aes.encrypt(master, secretKey: pinKey);
    final recoveryBox = await _aes.encrypt(master, secretKey: recoveryKey);

    // Write all key material first. The configured marker is written last.
    await _storage.write(key: '${_prefix}pin_salt', value: base64Encode(pinSalt));
    await _writeBox('pin_wrap', pinBox);
    await _storage.write(key: '${_prefix}recovery_salt', value: base64Encode(recoverySalt));
    await _writeBox('recovery_wrap', recoveryBox);
    await _storage.write(key: '${_prefix}configured', value: '1');
    _masterKey = master;
    return recoveryCode;
  }

  Future<bool> unlock(String pin) async {
    if (!await isConfigured) return false;
    try {
      final salt = await _readBytes('${_prefix}pin_salt');
      final key = await _derive(pin, salt);
      final master = await _aes.decrypt(await _readBox('pin_wrap'), secretKey: key);
      if (master.length != 32) return false;
      _masterKey = master;
      return true;
    } on Object {
      _masterKey = null;
      return false;
    }
  }

  /// Uses the recovery code to recover the master key and wrap it under a new PIN.
  Future<bool> recoverWithCode(String recoveryCode, String newPin) async {
    _validatePin(newPin);
    if (!await isConfigured) return false;
    try {
      final salt = await _readBytes('${_prefix}recovery_salt');
      final key = await _derive(_normalizeRecovery(recoveryCode), salt);
      final master = await _aes.decrypt(await _readBox('recovery_wrap'), secretKey: key);
      if (master.length != 32) return false;
      final random = Random.secure();
      final newSalt = _randomBytes(random, 16);
      final newPinKey = await _derive(newPin, newSalt);
      final newBox = await _aes.encrypt(master, secretKey: newPinKey);
      await _storage.write(key: '${_prefix}pin_salt', value: base64Encode(newSalt));
      await _writeBox('pin_wrap', newBox);
      _masterKey = master;
      return true;
    } on Object {
      _masterKey = null;
      return false;
    }
  }

  void lock() => _masterKey = null;

  Future<String> encryptText(String text) async {
    final master = _masterKey;
    if (master == null) throw StateError('Private notes are locked.');
    final box = await _aes.encrypt(utf8.encode(text), secretKey: SecretKey(master));
    return jsonEncode({
      'n': base64Encode(box.nonce),
      'c': base64Encode(box.cipherText),
      'm': base64Encode(box.mac.bytes),
    });
  }

  Future<String> decryptText(String encoded) async {
    final master = _masterKey;
    if (master == null) throw StateError('Private notes are locked.');
    final data = jsonDecode(encoded) as Map<String, dynamic>;
    final box = SecretBox(
      base64Decode(data['c'] as String),
      nonce: base64Decode(data['n'] as String),
      mac: Mac(base64Decode(data['m'] as String)),
    );
    return utf8.decode(await _aes.decrypt(box, secretKey: SecretKey(master)));
  }

  Future<SecretKey> _derive(String password, List<int> salt) => _kdf.deriveKey(
        secretKey: SecretKey(utf8.encode(password)),
        nonce: salt,
      );

  Future<void> _writeBox(String name, SecretBox box) async {
    await _storage.write(key: '$_prefix${name}_nonce', value: base64Encode(box.nonce));
    await _storage.write(key: '$_prefix${name}_cipher', value: base64Encode(box.cipherText));
    await _storage.write(key: '$_prefix${name}_mac', value: base64Encode(box.mac.bytes));
  }

  Future<SecretBox> _readBox(String name) async => SecretBox(
        await _readBytes('$_prefix${name}_cipher'),
        nonce: await _readBytes('$_prefix${name}_nonce'),
        mac: Mac(await _readBytes('$_prefix${name}_mac')),
      );

  Future<List<int>> _readBytes(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) throw StateError('Security key data is missing.');
    return base64Decode(value);
  }

  static List<int> _randomBytes(Random random, int length) =>
      List<int>.generate(length, (_) => random.nextInt(256));

  static String _makeRecoveryCode(Random random) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final raw = List<String>.generate(20, (_) => alphabet[random.nextInt(alphabet.length)]).join();
    return '${raw.substring(0, 5)}-${raw.substring(5, 10)}-${raw.substring(10, 15)}-${raw.substring(15)}';
  }

  static String _normalizeRecovery(String code) =>
      code.toUpperCase().replaceAll(RegExp(r'[^A-Z2-9]'), '');

  static void _validatePin(String pin) {
    if (!RegExp(r'^\d{6,12}$').hasMatch(pin)) {
      throw ArgumentError('PIN must contain 6 to 12 digits.');
    }
  }
}

