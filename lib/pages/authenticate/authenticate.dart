import 'package:flutter/material.dart';
import 'package:aid_scale/pages/authenticate/register.dart';
import 'package:aid_scale/pages/login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isRegister = false;
  void toggleRegister(){
    setState(() => isRegister = !isRegister);
  }
  @override
  Widget build(BuildContext context) {
    if(isRegister){
      return Register(toggleView: toggleRegister);
    }else {
      return LoginDemo(toggleView: toggleRegister);
    }
  }
}
