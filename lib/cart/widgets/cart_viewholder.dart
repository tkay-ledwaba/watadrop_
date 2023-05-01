
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/cart/views/cart_screen.dart';
import 'package:watadrop/common/database_helper.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

showCardWidget(myData, context, index, databaseHelper, updateListView()){

  TextEditingController qtyController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  var num_of_case = 1;
  var subtotal;

  num_of_case = myData[index].qty;
  qtyController.text = myData[index].qty.toString();
  totalController.text = myData[index].price.toString()+".00";

  return Card(
      shape: RoundedRectangleBorder( //<-- SEE HERE
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colorPrimary,
            backgroundImage: NetworkImage(myData[index].image),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(14, 0, 0,0),
                      child: Text(
                        myData[index].name.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700

                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.fromLTRB(18, 20, 0,0),
                      child: SizedBox(
                        width: 48,
                        child: TextField(
                          readOnly: true,
                          controller: totalController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){

                          if (num_of_case != 1) {
                            num_of_case--;
                            qtyController.text = num_of_case.toString();
                            subtotal = double.parse(myData[index].price)/myData[index].qty*num_of_case;

                            totalController.text = subtotal.toString()+'0';
                            Cart cart = Cart(
                              myData[index].id,
                              myData[index].name,
                              myData[index].image,
                              subtotal.toString(),
                              num_of_case,
                            );
                            Future<int> result = databaseHelper.updateCart(cart);

                            if (result != 0) {  // Success
                              showCustomSnackBar(context,'${myData[index].name} updated from cart', colorSuccess);
                              updateListView();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder:(context) => CartScreen())
                              );

                            } else {  // Failure
                              showCustomSnackBar(context, 'Failed to update cart', colorFailed);
                            }
                          }

                        }, icon: const Icon(Icons.indeterminate_check_box_sharp, color: Colors.lightBlue)),

                        SizedBox(
                          width: 12,
                          child: TextField(
                            readOnly: true,
                            controller: qtyController,
                            //decoration: InputDecoration(labelText: 'Enter Number'),
                          ),
                        ),

                        IconButton(onPressed: (){
                          if (num_of_case != 5){
                            num_of_case++;
                            qtyController.text = num_of_case.toString();
                            subtotal = double.parse(myData[index].price)/myData[index].qty*num_of_case;
                            totalController.text = subtotal.toString();

                            Cart cart = Cart(
                              myData[index].id,
                              myData[index].name,
                              myData[index].image,
                              subtotal.toString(),
                              num_of_case,
                            );

                            Future<int> result = databaseHelper.updateCart(cart);

                            if (result != 0) { // Success
                              showCustomSnackBar(context, '${myData[index]
                                  .name} updated from cart', colorSuccess);
                              updateListView();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      CartScreen())
                              );
                            }


                          }
                        }, icon: const Icon(Icons.add_box_sharp, color: Colors.lightBlue)),


                      ],
                    ),
                    IconButton(onPressed: (){
                      Future<int> result = databaseHelper.deleteCart(myData[index].id);

                      if (result != 0) {  // Success
                        showCustomSnackBar(context,'${myData[index].name} deleted from cart', colorSuccess);
                        updateListView();
                        count--;

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder:(context) => CartScreen())
                        );

                      } else {  // Failure
                        showCustomSnackBar(context, 'Failed to delete from cart', colorFailed);
                      }
                    }, icon: Icon(Icons.delete))
                  ],
                ),
              ),

            ],
          )
        ],
      )
  );

}