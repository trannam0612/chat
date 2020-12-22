import 'package:chat/checkdata.dart';
import 'package:chat/database.dart';
import 'package:chat/historychat.dart';
import 'package:chat/homepage.dart';
import 'package:chat/registerpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  String _email;
  String _pass;
  String name;
  String email;
  String _error1 = " Enter User name or Password";
  FireData _fireData = new FireData();

  Future<void> _login() async {
    try {
      print("Email: $_email Pass: $_pass");
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pass);
      print("User: $userCredential");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('myName', _email);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HistoryChat(email: email),
      ));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => loading(context),
      ));
      print(_error1);
    } catch (e) {
      print("Error 2");
    }
  }

  Widget loading(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyanAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                _error1,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Colors.grey,
                padding: EdgeInsets.all(20),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                )),
                child: Text('Login Now'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Image(
                image: AssetImage('assets/images/chat_start.png'),
                height: 180.0,
                width: 180.0,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text('Wellcom back!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ))),
              Text(
                'Login to continue using Chat',
                style: TextStyle(color: Colors.grey[700]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: TextFormField(
                  validator: (value) => value.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.')
                      ? "Enter email"
                      : null,
                  onChanged: (value) {
                    _email = value;
                    print("Email: $value");
                  },
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              TextFormField(
                validator: (value) => value.isEmpty ||
                        value.length < 6 ||
                        !value.contains(new RegExp(r'[a-z]'))
                    ? "Enter password"
                    : null,
                onChanged: (value) {
                  _pass = value;
                  print("Pass: $value");
                },
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.security),
                    suffixIcon: IconButton(
                      icon: Icon(_secureText
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          _secureText = !_secureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
                obscureText: _secureText,
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(130, 15, 130, 15),
                      color: Colors.blue[700],
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _login();
                        }
                      },
                      child: Text('Log In'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: RichText(
                  text: TextSpan(
                      text: 'New user?',
                      style: TextStyle(color: Colors.grey[800]),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ));
                              },
                            text: ' Register new account',
                            style: TextStyle(color: Colors.blue[800]))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
