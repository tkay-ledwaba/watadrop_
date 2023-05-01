
import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/orders/order_detail.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

import '../localwidgets/timeline.dart';

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