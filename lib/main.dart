// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/screens/addInv.dart';
import 'package:medtrack/screens/addMed.dart';
import 'package:medtrack/screens/home.dart';
import 'package:medtrack/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Home(),
    );
  }
}
