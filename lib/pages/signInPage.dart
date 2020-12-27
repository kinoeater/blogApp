import 'dart:convert';
import 'package:blogApp/pages/HomePage.dart';
import 'package:blogApp/pages/signUpPage.dart';
import 'package:flutter/material.dart';
import '../networkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText = "ERROR";
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue[200]],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated),
        ),
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email ile giriş",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                usernameFormField(),
                SizedBox(
                  height: 15,
                ),
                passwordFormField(),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                    };

                    var response =
                        await networkHandler.post("/user/login", data);

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      // print(output);
                      print(output['token']);
                      await storage.write(key: "Token", value: output['token']);
                      var readResponse = await storage.read(key: "Token");
                      print("Read response ///////////"+readResponse);

                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(),
                          ),
                          (route) => false);
                    } else {
                      String output = json.decode(response.body);
                      setState(() {
                        validate = false;
                        errorText = output;
                        print("/////" + output);
                        circular = false;
                      });
                    }

                    // setState(() {
                    //   circular = true;
                    // });

                    // if (_globalkey.currentState.validate()) {
                    //   // if valid send the data to REST data
                    //   // networkHandler.get("");
                    //   Map<String, String> data = {
                    //     "username": _usernameController.text,
                    //     "password": _passwordController.text,
                    //   };
                    //   print(data);
                    //   await networkHandler.post("/user/login", data);
                    //   setState(() {
                    //     circular = false;
                    //   });
                    // } else {
                    //   setState(() {
                    //     circular = false;
                    //   });
                    // }
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff00A86B),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "GİRİŞ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Parolanızı unuttunuz mu?",
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                      },
                      child: Text(
                        "Yeni kullanıcı oluşturun",
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameFormField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              errorText: errorText.contains("kullanıcı") ? errorText : null,
              hintText: "Kullanıcı Adı",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black38,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordFormField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: vis,
            decoration: InputDecoration(
              errorText: errorText.contains("Parola") ? errorText : null,
              hintText: "Parola",
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              //  helperText: "Parola en az 8 karakter olmalıdır!",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black38,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
