import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/user/forms/signup_form.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

import '../../common/style.dart';

void showLoginForm(context) {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String email;
  late String password;

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
                  content: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: colorSecondary)
                              ),
                              child: Text('LOGIN',textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            SizedBox(height: 16),

                            TextField(
                              controller: emailController,
                              onChanged: (value) {
                                email = value;
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Email Address',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),

                            SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              onChanged: (value) {
                                password = value;
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Password',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                              obscureText: true,
                            ),
                            SizedBox(height: 8),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorAccent
                                ),
                              ),
                            ),
                            SizedBox(height: 8),


                            ElevatedButton(
                                onPressed: () async {
                                  if (emailController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter email address.", colorFailed);
                                  } else if (passwordController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter password.", colorFailed);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                    );

                                    try {
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );

                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context) => HomeScreen()), (Route route) => false);

                                    } on FirebaseAuthException catch (e) {
                                      Navigator.pop(context);
                                      showCustomSnackBar(context, e.message.toString(), colorFailed);
                                    }
                                  };


                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50), // NEW
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                child: Text('Login', style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: colorAccent ,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                          showSignupForm(context);
                                        }
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },)
        );
      }
  );

}

