import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 3),
            ()=>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:(context) => MainPage())
            )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bodyWidget(),
      bottomSheet: bottomSheetWidget(),
    );
  }

  Widget bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(padding: EdgeInsets.all(32)
            , child: Image.asset('assets/images/logo.png'),),
        ),
      ],
    );
  }

  Widget bottomSheetWidget() {
    return Container(
      width: double.infinity,
      color: Colors.lightBlue,
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Water on the drop.'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)
          )
      ),
    );
  }
}

