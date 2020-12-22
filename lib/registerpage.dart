import 'package:chat/checkdata.dart';
import 'package:chat/database.dart';
import 'package:chat/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _formKey = GlobalKey<FormState>();
  String checkNumber = "1,2,3,4,5,6,7,8,9";
  bool _secureText = true;
  String _email;
  String _pass;
  String _name;
  String _phone;
  FireData fireData = new FireData();
  CheckInput checkInput = new CheckInput();
  Future<void> _createUser() async {
    try {
      print("Email: $_email Pass: $_pass Name: $_name Phone: $_phone");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pass);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
      print("User: $userCredential");
    } on FirebaseAuthException catch (e) {
      print("Error $e");
    } catch (e) {
      print("Error $e");
    }

    Map<String, String> userInfoMap = {
      "mail": _email,
      "pass": _pass,
      "name": _name,
      "phone": _phone
    };
    fireData.upLoadUserInfo(userInfoMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Image(
                image: AssetImage('assets/images/register.png'),
                height: 120.0,
                width: 120.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 6),
                child: Text('Wellcom Aboard!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    )),
              ),
              Text(
                'Signup with Chat in simple steps',
                style: TextStyle(color: Colors.grey[700]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
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
                style: TextStyle(fontSize: 15.0, color: Colors.black),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextFormField(
                  validator: (value) => value.isEmpty ? "Enter name" : null,
                  onChanged: (value) {
                    _name = value;
                    print("Name: $value");
                  },
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'User name',
                      prefixIcon: Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextFormField(
                  validator: (value) => value.isEmpty ||
                          value.length < 9 ||
                          value.contains(new RegExp(r'[a-z, A-Z]'))
                      ? "Enter phone"
                      : null,
                  onChanged: (value) {
                    _phone = value;
                    print("Phone: $value");
                  },
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(130, 15, 130, 15),
                      color: Colors.blue[700],
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _createUser();
                        }
                      },
                      child: Text('Create'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: RichText(
                  text: TextSpan(
                      text: 'Already a User?',
                      style: TextStyle(color: Colors.grey[800]),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ));
                              },
                            text: ' Login now',
                            style: TextStyle(color: Colors.blue[600]))
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
