import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watadrop/common/constants.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/orders/notes.dart';
import 'package:watadrop/orders/localwidgets/timeline.dart';

class OrderDetail extends StatefulWidget {
  final String order_id;
  const OrderDetail(this.order_id, {super.key});

  @override
  OrderDetailState createState() => OrderDetailState();

}

class OrderDetailState extends State<OrderDetail> {

  var status;
  var address;
  var datetime;
  var amount;
  var agent;
  var agent_id;
  var cart;

  late String message;
  late TextEditingController text_controller;

  @override
  void initState(){
    super.initState();
    text_controller = TextEditingController();
  }

  @override
  void dispose() {
    text_controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: colorAccent,
      // Appbar
      appBar: AppBar(
        // Title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorSecondary,), onPressed: (){
          Navigator.pop(context);
          },
        ),
        backgroundColor: colorPrimary,
        title: Text(' ${widget.order_id}', style: TextStyle(color: colorSecondary),),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.cancel_outlined))
        ],
      ),
      // Body
      body: StreamBuilder<QuerySnapshot>(
        ///
        stream: fireStore
            .collection('orders')
            .snapshots(),

        ///flutter async snapshot
        builder: (context, snapshot) {
          //List<JobCard> todoWidgets = [];

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final todoLists = snapshot.data!.docs;

          for (var todoList in todoLists) {
            final job_id = (todoList.data() as dynamic)['order_id'];

            if (job_id == widget.order_id){
              //final currentUser = user.email;
              address = (todoList.data() as dynamic)['address'];
              datetime = (todoList.data() as dynamic)['datetime'];
              amount = (todoList.data() as dynamic)['amount'];
              agent = (todoList.data() as dynamic)['agent'];
              agent_id = (todoList.data() as dynamic)['agent_id'];
              status = (todoList.data() as dynamic)['status'];
              cart = (todoList.data() as dynamic)['cart'];
            }
          }

          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          shape: RoundedRectangleBorder( //<-- SEE HERE
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Column(
                                       //crossAxisAlignment: CrossAxisAlignment.stretch,
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('Address:'),
                                         Text('Date:'),
                                         Text('Paid:'),
                                         Text('Driver:'),
                                         Text('Cart:')
                                       ],
                                     ),
                                     Column(
                                       //crossAxisAlignment: CrossAxisAlignment.stretch,
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       children: [
                                         Text('$address'),
                                         Text('$datetime'),
                                         Text('$amount'),
                                         Text('${agent}'),
                                         Text('${cart.toString().replaceAll(", ", "\n")}')
                                       ],
                                     )
                                   ],
                                 ),
                                 Timeline(status),
                                 Text(checkStatus(status)),

                              ],
                            ),
                          )
                      )
                    ],
                  )
              ),

              Notes(widget.order_id),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                  height: 56,
                  width: double.infinity,
                  color: colorPrimary,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 20, ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: TextField(
                          controller: text_controller,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                              isDense: true,                      // Added this
                              contentPadding: const EdgeInsets.all(12),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      FloatingActionButton(
                        onPressed: (){
                          fireStore.collection('notes').add({
                            'job_id': widget.order_id,
                            'name': user!.displayName,
                            'user_id': user!.uid,
                            'agent': agent,
                            'agent_id': agent_id,
                            'message': text_controller.text,
                            'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                            'time': DateFormat.Hm().format(DateTime.now()),
                            'message_type':'receiver'
                          }).then((value) => text_controller.clear());

                        },
                        child: Icon(Icons.send,color: Colors.white,size: 18,),
                        backgroundColor: colorAccent,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}