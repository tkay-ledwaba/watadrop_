import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/main.dart';

import '../../common/style.dart';
import '../../widgets/custom_snackbar.dart';

void showOTPDialog(context, phone) {

  String? _verificationCode;

  TextEditingController _textFieldController = TextEditingController();
  late String valueText;
  late String codeDialog;
  late String code;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackBar(context, e.message, colorFailed);
        },
        codeSent: (String? verficationID, int? resendToken) {
          _verificationCode = verficationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationCode = verificationID;
        },
        timeout: Duration(seconds: 120));
  }

  _verifyPhone();

  showDialog(
      context: context,
      builder: (context){

        return ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                      side: BorderSide(
                        color: Colors.black,
                      )),
                  title: Text('OTP Sent to ${phone}.\nPlease Enter OTP.'),
                  content:  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: colorSecondary)
                        ),
                        child: Text('Verification code has been sent to:\n$phone',textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _textFieldController,
                        onChanged: (value) {
                          code = value;
                        },
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: border_radius
                            ),
                            labelText: 'Verification Code',
                            isDense: true,
                            // Added this
                            contentPadding: EdgeInsets.all(8)),
                      ),

                    ],
                  ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    //Resend Verification Code
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                    );


                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    side: BorderSide(color: Colors.black, width: 1),
                                    //minimumSize: const Size.fromHeight(50), // NEW
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  child: Text('RESEND', style: TextStyle(color: Colors.black),)
                              )
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_textFieldController.text.isEmpty){
                                      showCustomSnackBar(context, "Please enter verification code", colorFailed);
                                    } else
                                    {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                      );

                                      codeDialog = code;

                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithCredential(PhoneAuthProvider.credential(
                                            verificationId: _verificationCode!, smsCode: codeDialog))
                                            .then((value) async {
                                          if (value.user != null) {




                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                                    (route) => false);
                                          }
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

                                        Navigator.of(context).push(
                                            MaterialPageRoute
                                              (builder: (context)=>MainPage()
                                            )
                                        );
                                      }


                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    //minimumSize: const Size.fromHeight(50), // NEW
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  child: Text('CONFIRM', style: TextStyle(color: Colors.white),)
                              )
                          ),
                        ],
                      ),

                    ]

                ),
              );
            },)
        );
      }
  );


}

