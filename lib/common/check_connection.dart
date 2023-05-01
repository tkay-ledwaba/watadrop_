import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';


Future<void> check_connection(context) async {
  final result = await InternetAddress.lookup('google.com');
  if(result.isEmpty && result[0].rawAddress.isEmpty){
    showDialog(
        context: context,
        builder: (context){

          return ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                  backgroundColor: colorAccent,
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
                                child: Text('CONNECTION ERROR',textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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

}

