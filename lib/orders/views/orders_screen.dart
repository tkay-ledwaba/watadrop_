import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/common/constants.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/orders/order_detail.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

import '../localwidgets/timeline.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() =>
      _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrimary,
        appBar: AppBar(
          backgroundColor: colorPrimary,
          foregroundColor: colorSecondary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorSecondary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          //centerTitle: true,
          title: Text("ORDERS"),
          elevation: 0,
        ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            ///
            stream: fireStore
                .collection('orders')
                .orderBy('status', descending: true)
                .snapshots(),

            ///flutter async snapshot
            builder: (context, snapshot) {
              List<Order> todoWidgets = [];
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue
                  ),
                );
              }
              final todoLists = snapshot.data!.docs;

              for (var todoList in todoLists) {
                final order_id = (todoList.data() as dynamic)['order_id'];
                final amount = (todoList.data() as dynamic)['amount'];
                final address = (todoList.data() as dynamic)['address'];
                final datetime = (todoList.data() as dynamic)['datetime'];
                var  status = (todoList.data() as dynamic)['status'];
                final user_id = (todoList.data() as dynamic)['user_id'];

                if (user!.uid.toString() == user_id.toString()){
                  String convertStatus = checkStatus(status);

                  final orderWidget = Order(
                    order_id: '$order_id',
                    amount: '$amount',
                    datetime: datetime,
                    address: '$address',
                    status: convertStatus,
                    ticks: status,
                  );

                  if (status > -1 && status <3)
                    todoWidgets.add(orderWidget);
                }

              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: ListView(children: todoWidgets),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Order extends StatelessWidget {
  Order({ //required this.isLoggedIn,
    required this.order_id,
    required this.amount,
    required this.datetime,
    required this.address,
    required this.status,
    required this.ticks
  });
  final String order_id;
  final String amount;
  final String datetime;
  final String address;
  final String status;//final bool isLoggedIn;
  final int ticks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: InkWell(
        //padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: Card(
            shape: RoundedRectangleBorder( //<-- SEE HERE
              side: BorderSide(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order_id,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0,
                              fontWeight: FontWeight.bold
                              ,color: Colors.black)
                      ),
                      Text('R${amount}',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0,
                              fontWeight: FontWeight.bold
                              ,color: Colors.black)
                      )
                    ],
                  ),
                  Text(address,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      )
                  ),

                  Text('$datetime',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      )
                  ),

                  Timeline(ticks),

                  Text(status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      )
                  )
                ],
              ),
            )
        ),
        onTap: (){
          if (ticks > 0){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>OrderDetail(order_id)));
          } else {
            showCustomSnackBar(context, "Your order hasn't been accepted yet. Please be patient.", colorSecondary);
          }
        },
      ),
    );
  }


}