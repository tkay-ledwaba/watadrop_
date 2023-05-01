import 'package:flutter/material.dart';

void showCancelDialog(context, job_id) {
  showDialog(
      context: context,
      builder: (context){

        return ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0)
                      )
                  ),
                  title: Text('Cancel Request? ' , textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize:18),
                  ),
                  content: SingleChildScrollView(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Are you sure you want to cancel '+ job_id + '?', textAlign: TextAlign.left,
                          style: const TextStyle(fontSize:12),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text("Yes"),
                      onPressed: () {
                        print("Reschedule");
                      },
                    ),
                    ElevatedButton(
                      child: Text('No'),
                      onPressed: () {
                        print("Cancel");
                      },
                    ),
                  ],

                ),
              );
            },)
        );
      }
  );


}