import 'package:apk_keuangan/pages/login_page.dart';
import 'package:apk_keuangan/pages/main_page.dart';
import 'package:apk_keuangan/pages/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
