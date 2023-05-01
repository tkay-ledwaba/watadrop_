import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/user/forms/login_form.dart';
import 'package:watadrop/user/forms/signup_form.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: colorAccent,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.all(48),

          child: Card(
            shape: RoundedRectangleBorder( //<-- SEE HERE
              side: BorderSide(
                  color: Colors.black,
                  width: 1
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Image.asset('assets/images/logo.png'),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: (){
                                    showSignupForm(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    side: BorderSide(color: Colors.black, width: 1),
                                    //minimumSize: const Size.fromHeight(50), // NEW
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  child: Text('SIGN UP', style: TextStyle(color: Colors.black),)
                              )
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: (){
                                    showLoginForm(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    //minimumSize: const Size.fromHeight(50), // NEW
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  child: Text('LOGIN', style: TextStyle(color: Colors.white),)
                              )
                          ),
                        ],
                      ),
                    ],
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