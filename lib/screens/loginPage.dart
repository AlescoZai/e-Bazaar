// ========================== LoginPage ===============================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/screens/signupPage.dart';
import 'package:shopping_cart/ui/homepage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  bool loading = false;
  bool hidePass = true;
  bool isLogedin = false;

  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });

    await firebaseAuth.currentUser().then((user) {
      if (user != null) {
        setState(() => isLogedin = true);
      }
    });
    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            // stops: [0.1, 0.4, 1.5, 0.0],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.red[400],
              Colors.red[100],
              Colors.teal[100],
              Colors.teal[400],
            ],
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                alignment: Alignment.center,
                child: Text(
                  "e-Bazaar",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                // alignment: Alignment.center,
                child: Text(
                  "Welcome Back. We Are Very Much Excited About Your Next Shopping",
                  style: TextStyle(),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      "Login",
                      style: _loginRegStyles(),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      alignment: Alignment.center,
                      child: Text(
                        "Register",
                        style: _loginRegStyles(),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Icons.alternate_email,
                              color: Colors.blueGrey),
                          hintText: "Email",
                          labelStyle: TextStyle(
                              // color: Colors.white,
                              ),
                          labelText: "Email"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Provide Email";
                        }
                      },
                      onSaved: (val) {
                        _emailController.text = val;
                      },
                      autocorrect: true,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      // obscureText:hidepass we toggle when user clicks the icon
                      obscureText: hidePass,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePass = false;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "Password",
                          labelText: "Password"),
                      validator: (val) {
                        if (val.length < 6) {
                          return "Passsword must contain atleast 6 characters";
                        } else if (val.isEmpty) {
                          return "Password field can't be empty";
                        }
                      },
                      onSaved: (val) {
                        _passwordController.text = val;
                      },
                      autocorrect: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    //  ================== Login Btn =======================
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      minWidth: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "Login",
                            style: _btnStyle(),
                          ),
                        ),
                      ),
                      onPressed: () {
                        signIn();
                      },
                      color: Color(0xFFB33771),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFFB33771),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),

                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: loading ?? true,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _loginRegStyles() {
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 18.0,
      letterSpacing: 0.8,
      color: Color(0xFFB33771),
    );
  }

  Future signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
