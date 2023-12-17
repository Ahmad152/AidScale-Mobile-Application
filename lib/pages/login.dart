import 'package:aid_scale/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:aid_scale/pages/authenticate/auth.dart';


class LoginDemo extends StatefulWidget {
  final Function toggleView ;

  LoginDemo({required this.toggleView});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {

  final AuthService _auth = AuthService();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('asset/scale.jpg')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              TextButton(
                onPressed: (){
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    setState((){ loading = true; });
                    dynamic result = await _auth.signInEmail(_email.text, _password.text);
                    if(result == null){
                      setState((){ loading = false; });
                      _password.clear();
                      print('error sign up');
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              TextButton(
                onPressed: (){
                    widget.toggleView();
                },
                child: Text(
                  'New User? Create Account',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}