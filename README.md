# Gappe

Gappe is a chatroom app where users can start chatting without the need for login credentials. Users simply need to enter a username to begin using the app. The app utilizes Firestore for real-time messaging and data storage.

## Apk

https://drive.google.com/file/d/1XooHDD0jmjC4SrzBliDbOtULalIg6wrD/view?usp=share_link

## Features

- User-friendly interface: The app provides a simple and intuitive interface for seamless communication.
- No login required: Users can start chatting immediately by entering a username.
- Real-time messaging: Messages are updated in real-time, allowing users to have dynamic conversations.
- Firestore integration: Firebase Firestore is used as the backend database for storing and retrieving chat messages.

## Preview


https://github.com/pran9v/gappe/assets/109653505/9ee46f04-471d-49f6-89ef-1e90043df6c2



## Getting Started

To run the app locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/pran9v/gappe.git

2. Ensure you have Flutter and Dart installed on your machine.
3. Install dependencies by running the following command in the project directory:
   ```
   flutter pub get
   ```
4. Create a Firebase project and set up Firestore. Refer to the Firebase documentation for detailed instructions.
5. Run the app on a simulator or connected device:
  ```
  flutter run
  ```
6. Start chatting without the need for login credentials!

## Dependencies

flutter: ^3.7.3
cloud_firestore: ^4.5.0
intl: ^0.17.0
