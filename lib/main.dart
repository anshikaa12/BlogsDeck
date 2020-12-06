import 'package:blog_app_final/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

           canvasColor: Color(0xFF111214),
           accentColor: Colors.blue,

    ),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    );
    }




        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}
