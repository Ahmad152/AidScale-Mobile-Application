//import 'dart:js';
import 'package:aid_scale/pages/authenticate/auth.dart';
import 'package:flutter/services.dart';
//import 'dart:html';
import 'package:firebase_core/firebase_core.dart';


import 'package:flutter/material.dart';
import 'package:aid_scale/pages/statistics.dart';
import 'package:aid_scale/pages/wrapper.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp( StreamProvider.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => Wrapper(),
        '/Statistics': (context) => Statistics(),
      },
    ),
  ));
}
