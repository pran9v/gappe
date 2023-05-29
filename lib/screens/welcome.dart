import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gappe/screens/chatroom.dart';

class Welcome extends StatelessWidget {
  final TextEditingController usernameTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Welcome({super.key});

  void saveUsername(BuildContext context, String username) async {
    if (_formKey.currentState!.validate()) {
      // Create a new Firestore document for the user's name
      await FirebaseFirestore.instance.collection('users').add({
        'name': username,
      });

      // Navigate to the chatroom home screen;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatRoom(username: username)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 250),
                const ProfileImage(),
                const SizedBox(height: 80),
                UsernameTextField(controller: usernameTextEditingController),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () => saveUsername(
                      context, usernameTextEditingController.text.trim()),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'Rubik-Medium',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/profile.png"), context);
    return const Padding(
      padding: EdgeInsets.only(right: 120, left: 120),
      child: Image(
        image: AssetImage('assets/images/profile.png'),
      ),
    );
  }
}

class UsernameTextField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameTextField({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter a username";
          }
          return null;
        },
        decoration: InputDecoration(
          label: const Center(
            child: Text('Enter your username'),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(width: 3, color: Colors.orange),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Rubik-Medium',
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
