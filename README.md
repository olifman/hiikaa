# Hiikaa: Offline English / Afaan Oromoo / Amharic Translator

An Android app that translates common phrases between English, Afaan Oromoo and Amharic **without internet**.

## Features
- Offline phrasebook (65 phrases, 9 categories) stored in SQLite
- Translate in any direction between the three languages (swap button)
- History and favorites
- Searchable phrasebook with Draft / Verified labels

## Why a phrasebook first?
We tested NLLB, MADLAD and OPUS-MT models offline. On our target phone (1.9 GB RAM, 32-bit) the models were too large or too inaccurate for Afaan Oromoo, so verified phrases are used first and a compact model is planned for a later version.

## Status
Version 0.1 (beta). Phrases are drafts pending native-speaker review.

## Run
    flutter pub get
    flutter run

## Build APK
    flutter build apk --release
