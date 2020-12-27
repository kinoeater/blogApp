import 'package:blogApp/pages/HomePage.dart';
import 'package:blogApp/pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = welcomePage();
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(key: "token");

    if (token != null) {
      print("Daha önce giriş yapılmış");

      page = HomePage();
    } else {
      print("Daha önce giriş yapılmamış");
      setState(() {
        page = welcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.oswaldTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: page,
    );
  }
}
