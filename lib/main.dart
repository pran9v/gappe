import 'package:flutter/material.dart';
import 'package:gappe/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/initial.png"), context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: Builder(builder: (context) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.width * 0.50,
                child: const Image(
                  image: AssetImage('assets/images/initial.png'),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 60),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Welcome()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.yellow,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.orangeAccent,
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Start chatting",
                        style: TextStyle(
                          fontFamily: 'Rubik-Medium',
                          fontSize: 23,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.75,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Text(
                    'No login required!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rubik-Italic-VariableFont_wght',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
