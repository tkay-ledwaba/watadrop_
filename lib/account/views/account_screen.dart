import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/main.dart';
import 'package:watadrop/user/forms/signup_form.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() =>
      _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  /// form variable
  late String name;
  late String lastname;
  late String email;
  late String phone;
  late String address;
  late String password;
  late TextEditingController nameTextController;
  late TextEditingController lastnameTextController;
  late TextEditingController emailTextController;
  late TextEditingController phoneTextController;
  late TextEditingController addressTextController;
  late TextEditingController passwordTextController;

  @override
  void initState() {
    super.initState();
    //getCurrentUser();
    nameTextController = TextEditingController();
    lastnameTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    addressTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    lastnameTextController.dispose();
    emailTextController.dispose();
    addressTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    emailTextController.text = user!.email.toString();

    return Scaffold(
      backgroundColor: colorAccent,
      appBar: AppBar(
          backgroundColor: colorPrimary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorSecondary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          //centerTitle: true,
          title: Text('ACCOUNT', style: TextStyle(color: colorSecondary),),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  child: Icon(Icons.exit_to_app, color: colorSecondary,),
                  onTap: () {

                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (
                            BuildContext context) => MainPage(),
                      ), (route) => false,//if you want to disable back feature set to false
                    );
                  },
                )
            )
          ]

      ),
      body:  Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          shape: RoundedRectangleBorder( //<-- SEE HERE
            side: BorderSide(
              color: Colors.black,
            ),
          ),
          child: Padding(padding: EdgeInsets.all(8),
              child: FutureBuilder(
                future: fetch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Text("Loading data...Please wait");
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ListView(
                          children: <Widget>[
                            const SizedBox(height: 16),
                            TextField(
                              controller: nameTextController,
                              onChanged: (value) {
                                name = value;
                              },
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Name',
                                  isDense: true,                      // Added this
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: lastnameTextController,
                              onChanged: (value) {
                                lastname = value;
                              },
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Last Name',
                                  isDense: true,                      // Added this
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: emailTextController,
                              onChanged: (value) {
                                email = value;
                              },
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Email Address',
                                  isDense: true,                      // Added this
                                  contentPadding: EdgeInsets.all(8)
                              ),

                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: phoneTextController,
                              onChanged: (value) {
                                phone = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: border_radius),
                                isDense: true, // Added this
                                contentPadding: EdgeInsets.all(8),
                                labelText: 'Phone Number',
                                prefix: Text('+27'),
                              ),
                              maxLength: 9,
                              keyboardType: TextInputType.phone,
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 8),

                            TextField(
                                readOnly: true,
                                controller: addressTextController,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Address:',
                                  hintText: 'Search address',
                                  isDense: true,                      // Added this
                                  contentPadding: EdgeInsets.all(8),
                                ),
                                maxLines: 5, // <-- SEE HERE
                                minLines: 1,
                                onTap: (){
                                  //showAddressPickerDialog(context, addressTextController);
                                }
                            ),
                            const SizedBox(height: 32),
                            Material(
                              // elevation: 5.0,
                                color: colorSecondary,
                                borderRadius: border_radius,
                                child: MaterialButton(
                                    minWidth: 200.0,
                                    height: 42.0,
                                    child: const Text(
                                      'Change Password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: (){

                                    }
                                )
                            ),
                            const SizedBox(height: 32),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Material(
                                // elevation: 5.0,
                                  color: colorAccent,
                                  borderRadius: border_radius,
                                  child: MaterialButton(
                                      minWidth: 200.0,
                                      height: 42.0,
                                      child: const Text(
                                        'Save & Close',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: (){
                                        user!.updateDisplayName(nameTextController.text +' '+lastnameTextController.text);
                                      }
                                  )
                              ),
                            ),
                          ]
                      )
                  );
                },
              )),
        ),
      ),
    );
  }

  fetch() async {
    if (user != null) {
      try {
        var doc = await fireStore.collection('users').doc(user!.uid).get();
        print(doc);
       if (doc.exists){
         nameTextController.text = doc.data()!['name'];
         lastnameTextController.text = doc.data()!['lastname'];
         phoneTextController.text = doc.data()!['phone'].substring(3);
         addressTextController.text = ' ${doc.data()!['address'].toString().replaceAll(",", "\n")}';
         return doc.exists;
       } else {
         return showSignupForm(context);}

      } catch (e) {
        showCustomSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

}

