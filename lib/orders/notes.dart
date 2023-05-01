import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/style.dart';
class Notes extends StatelessWidget{
  final String job_id;
  const Notes(this.job_id, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      ///
      stream: fireStore
          .collection('notes')
          .orderBy('time', descending: true)
          .snapshots(),

      ///flutter async snapshot
      builder: (context, snapshot) {
        List<MessageBubble> todoWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final todoLists = snapshot.data!.docs;

        for (var todoList in todoLists) {
          final name = (todoList.data() as dynamic)['name'];
          final jobID = (todoList.data() as dynamic)['job_id'];
          final user_id = (todoList.data() as dynamic)['user_id'];
          final message = (todoList.data() as dynamic)['message'];
          final message_type = (todoList.data() as dynamic)['message_type'];
          final time = (todoList.data() as dynamic)['time'];

          if(job_id == jobID){

            final messageWidget = MessageBubble(
              name: '$name',
              //isLoggedIn: '$currentUser',
              message: '$message',
              message_type: message_type,
              time: '$time',
            );

            todoWidgets.add(messageWidget);

          }
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: todoWidgets,
              reverse: true,),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {//required this.isLoggedIn,
        required this.name,
        required this.message,
        required this.message_type,
        required this.time,
      });
  final String name;
  final String time;
  final String message;
  final String message_type;
  //final String message;
  //final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 6,right: 6,top: 4,bottom: 4),
            child: Align(
                alignment: (message_type == "receiver"?Alignment.topLeft:Alignment.topRight),
                child: Card(shape: RoundedRectangleBorder( //<-- SEE HERE
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                    color: (message_type  == "receiver"?Colors.grey.shade200:colorAccent),
                    child:  Padding(
                      padding: EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Text(name,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16.0, color: Colors.black)
                            ),
                            Text(message, style: TextStyle(fontSize: 15)),
                            Text('$time',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                )
                            )
                          ],
                        ),
                    )
                ),
            ),
          ),
        ],
      );
  }
}