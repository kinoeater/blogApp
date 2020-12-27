import 'package:blogApp/pages/signInPage.dart';
import 'package:blogApp/pages/signUpPage.dart';
import 'package:flutter/material.dart';

class welcomePage extends StatefulWidget {
  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // animation 1
    _controller1 = AnimationController(
      duration: Duration(
        milliseconds: 350,
      ),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.bounceInOut));
    // Animation 2
    _controller2 = AnimationController(
      duration: Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.bounceInOut));

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SlideTransition(
                  position: animation1,
                  child: Text(
                    "Almanya'da Yaşam",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Almanya'da yaşam hakkında herşey...",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              boxContainer(
                  "assets/images/google.png", "Google ile giriş yapın", null),
              SizedBox(
                height: MediaQuery.of(context).size.height / 250,
              ),
              boxContainer("assets/images/facebook.png",
                  "Facebook ile giriş yapın", null),
              SizedBox(
                height: MediaQuery.of(context).size.height / 250,
              ),
              boxContainer("assets/images/email.png", "Email ile kayıt olun",
                  onEmailClick),
              SizedBox(
                height: MediaQuery.of(context).size.height / 250,
              ),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zaten hesabınız var mı?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 50,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ));
                      },
                      child: Text(
                        "GİRİŞ YAPIN",
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 250,
              ),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Giriş yapmadan",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 50,
                    ),
                    Text(
                      "DEVAM ET",
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onFBLogin() async {}
  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }

  Widget boxContainer(String path, String text, onClick) {
    // custom widget
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 140,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Image.asset(
                    path,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
