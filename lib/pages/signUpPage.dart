import 'package:blogApp/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../networkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorTextUsername;
  String errorTextEmail;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email ile kayıt olun",
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
              emailFormField(),
              passwordFormField(),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  await checkUser();
                  await checkEmail();
                  if (_globalkey.currentState.validate() && validate) {
                    // if valid send the data to REST data
                    // networkHandler.get("");
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                      "email": _emailController.text,
                    };

                    var response =
                        await networkHandler.post("/user/register", data);
                       

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print("///registiration output///" + output.toString());

                      Map<String, String> loginData = {
                        "username": _usernameController.text,
                        "password": _passwordController.text,
                      };

                      var loginResponse =
                          await networkHandler.post("/user/login", loginData);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Map<String, dynamic> output =
                            json.decode(loginResponse.body);
                        // print(output);
                        // print(output['token']);
                        await storage.write(
                            key: "Token", value: output['token']);
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
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Network Ettor")));
                      }
                    }

                    setState(() {
                      circular = false;
                    });
                  } else {
                    setState(() {
                      circular = false;
                    });
                  }
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
                            "KAYIT OL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        //   circular = false;
        validate = false;
        errorTextUsername = "Kullanıcı adı boş bırakılamaz";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");

      if (response['Status']) {
        //  circular = false;
        validate = false;
        errorTextUsername = response['msg'];  // bu kullanıcı adı alınmış
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }


  checkEmail() async {
    if (_emailController.text.length == 0) {
      setState(() {
        //   circular = false;
        validate = false;
        errorTextEmail = "Email boş bırakılamaz";
      });
    } else {
      var response =
          await networkHandler.get("/user/checkemail/${_emailController.text}");

      if (response['Status']) {
        //  circular = false;
        // print("//////////////" + response['Status'].toString());
        // print("/////" + _emailController.text);
        validate = false;
        errorTextEmail = response['msg'];
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }

  Widget usernameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                errorText: errorTextUsername,
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
      ),
    );
  }

  Widget passwordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.length < 8 || value.isEmpty) {
                  return "En az 8 karakter bir parola giriniz!";
                }
              },
              obscureText: vis,
              decoration: InputDecoration(
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
      ),
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value.isEmpty || !value.contains("@"))
                  return "Geçerli bir email giriniz!";
              },
              decoration: InputDecoration(
                errorText: errorTextEmail,
                hintText: "Emai",
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
      ),
    );
  }
}
