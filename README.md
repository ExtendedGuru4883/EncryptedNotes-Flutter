# EncryptedNotes Flutter frontend

This is a Flutter-based frontend application designed to connect to the API provided by [EncryptedNotes](https://github.com/ExtendedGuru4883/EncryptedNotes). The app allows users to manage encrypted notes from a mobile or desktop interface.

---

## Purpose

This project is for demonstrative purposes only and is **not intended for real-world, security-sensitive use**.  
It showcases a cross-platform frontend for encrypted notes, built with Flutter and Dart, designed to interface with the EncryptedNotes API using REST.  
Encryption and security logic follow a **Zero-Knowledge Security Model**, meaning all encryption and decryption are performed client-side. Passwords are never sent to the server, and authentication uses a challenge-response protocol with public/private key pairs and nonce signatures. All notes are end-to-end encrypted, and only encrypted data is transmitted or stored.

---

## Features

- Connects to the EncryptedNotes backend via REST API
- User authentication and encrypted note management (create, view, update, delete)
- Modular architecture using Dart and Flutter
- Cross-platform: Android, iOS, desktop (with Flutter support)
- Zero-Knowledge: All sensitive operations handled on the client

---

## Technologies

- **Flutter** (Dart)

---

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/ExtendedGuru4883/EncryptedNotes-Flutter.git
   cd ITS-flutter
   ```

2. **Create a `.env` file in the root folder** with the following variable:
   ```env
   BASE_URI=https://your-api-domain.com/api
   ```
   Replace `https://your-api-domain.com/api` with the URI where your EncryptedNotes API is running.  
   The app expects the backend to be reachable at the `/api` endpoint.

3. **Install dependencies:**
   ```sh
   flutter pub get
   ```

4. **Run the code generator:**
   ```sh
   dart run build_runner build -d
   ```

5. **Run the app:**
   ```sh
   flutter run
   ```

---

## Security Notice

This project is not intended for production use and has not been security audited.  
Do not use it to store or transmit sensitive data.

---

## License

See [LICENSE](LICENSE) for details.

