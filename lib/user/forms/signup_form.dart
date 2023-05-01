import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/user/forms/login_form.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

import '../../common/style.dart';

void showSignupForm(context) {

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String first_name;
  late String last_name;
  late String phone;
  late String email;
  late String city;
  late String password;

  showDialog(
      context: context,
      barrierDismissible: false,
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
                              child: Text('SIGN UP',textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              onChanged: (value) {
                                first_name = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Name',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: lastnameController,
                              onChanged: (value) {
                                last_name = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Last Name',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: emailController,
                              onChanged: (value) {
                                email = value.trim();
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
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                phone = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              maxLength: 9,

                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Phone Number',
                                  prefix: Text('+27'),
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)
                              ),

                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: cityController,
                              onChanged: (value) {
                                city = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'City',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              onChanged: (value) {
                                password = value.trim();
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
                            TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Confirm Password',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                              obscureText: true,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                                onPressed: () async {

                                  if (nameController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter name", colorFailed);
                                  } else if (lastnameController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter lastname", colorFailed);
                                  } else if (emailController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter email address", colorFailed);
                                  } else if (phoneController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter phone number", colorFailed);
                                  } else if (cityController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter city", colorFailed);
                                  } else if (passwordController.text.isEmpty){
                                    showCustomSnackBar(context, "Please enter password", colorFailed);
                                  } else if (passwordController.text != confirmPasswordController.text){
                                    showCustomSnackBar(context, "Password mismatch", colorFailed);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                    );

                                    try {
                                      final results = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                                      final user = FirebaseAuth.instance.currentUser!;

                                      if (results.user != null){
                                        fireStore.collection('users').doc(user.uid).set({
                                          'name': first_name,
                                          'lastname': last_name,
                                          'email' : email,
                                          'phone': '+27'+phone,
                                          'address': city,
                                          'joined': Timestamp.now(),
                                          'user_id': user.uid,
                                        }).then((value) => print("Added"));

                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomeScreen()),
                                                (route) => false
                                        );
                                      }



                                    } on FirebaseAuthException catch (e) {
                                      Navigator.pop(context);
                                      showCustomSnackBar(context, e.message.toString(), colorFailed);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50), // NEW
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                child: Text('SIGN UP', style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: colorAccent ,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                          showLoginForm(context);
                                        }
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(

                              child: Text("By pressing continue you consent to get calls, WhatsApp or SMS messages, including automated means from WatADrop and it's affiliates.",
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10, color: colorSecondary),
                              ),
                            )
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

