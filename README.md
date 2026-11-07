# 🌍 Hiikaa

### One app. Three languages. No internet required.

Hiikaa is an offline language companion for **English, Afaan Oromoo, and Amharic**. It helps users find useful translations and language resources without needing an internet connection.

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Version-0.3.0-7C4DFF" />
  <img src="https://img.shields.io/badge/Internet-Not%20Required-2E7D32" />
</p>

---

## ✨ Features

- 🌐 **Three languages:** English, Afaan Oromoo, and Amharic.
- 📖 **Offline phrasebook:** Search useful phrases in all three languages.
- 🔎 **Sentence search:** Search 2,009 sentence pairs from the FLORES-200 dataset.
- 💻 **Technology vocabulary:** Explore technology terms and explanations in three languages.
- 📝 **Notes:** Create and manage personal notes.
- 🔐 **Private notes:** Protect private notes using encryption.
- ⭐ **Favorites and history:** Keep useful translations close at hand.
- 📵 **Offline access:** Core language resources are available without an internet connection.

## 🧰 Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Builds the Android application interface. |
| Dart | Main programming language used to develop Hiikaa. |
| SQLite / sqflite | Stores phrases and other app data locally. |
| SharedPreferences | Saves small settings and preferences. |
| path / path_provider | Manages local database and file paths. |
| AES-256-GCM | Encrypts private note data. |
| PBKDF2 / HMAC-SHA256 | Derives encryption keys from a PIN or recovery code. |
| flutter_secure_storage | Securely stores sensitive key material. |
| Flutter Quill | Provides rich-text editing for notes. |
| url_launcher | Opens email, phone, Telegram, and web links. |
| Noto Sans Ethiopic | Supports Ethiopic characters used by Amharic. |

## 📚 Language Data

Hiikaa includes **2,009 sentence pairs** from the FLORES-200 dataset by Meta AI.

- Dataset: [FLORES-200](https://github.com/facebookresearch/flores)
- License: [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

The app also includes its own phrasebook and technology vocabulary.

## 🔒 Privacy and Offline Use

Hiikaa is designed to make its core language resources available offline. Phrase and sentence searches use data bundled with or stored locally in the application.

Private notes use AES-256-GCM encryption. Sensitive key material is protected using secure storage.

## 🚀 Run the Project

Make sure Flutter is installed, then run:

```bash
git clone https://github.com/olifman/hiikaa.git
cd hiikaa
flutter pub get
flutter run
```

## 📦 Build APK

```bash
flutter build apk --release
```

## 👨‍💻 Developer

**Lamesa Bekele Gemechu**

Software Engineering Student
Bule Hora University

- GitHub: [olifman](https://github.com/olifman)
- Portfolio: [lamesa-bekele.netlify.app](https://lamesa-bekele.netlify.app)

---

<p align="center">
  Made with ❤️ using Flutter
</p>
