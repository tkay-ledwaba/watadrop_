
import 'package:flutter/material.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/views/detail_screen.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

class Product extends StatelessWidget {
  Product(
      {required this.id,
        required this.name,
        required this.image,
        required this.qty,
        required this.volume,
        required this.price,
        required this.discount,
        required this.description,
        required this.category_id,
      });
  final int category_id;
  final int id;
  final String name;
  final String description;
  final String image;
  final int qty;
  final int volume;
  final int price;
  final int discount;

  TextEditingController qtyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    String display_name = "$name (${volume}ml x $qty)";

    if (volume >999){

      if (qty == 1){
        display_name = "$name (${volume/1000}L)";
      } else {
        display_name = "$name (${volume/1000}L x $qty)";
      }
    }

    if (category_id == 1){
      display_name = display_name+" (Refill)";
    }

    return Card(
        shape: RoundedRectangleBorder( //<-- SEE HERE
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: 88,
                    width: 88,
                    child: Image.network('$image'),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(left: 4, top: 8),
                  child: Text(' $display_name',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.black,
                      )
                  )
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text('R$price.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          )
                      ),),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: colorAccent,
                        onPrimary: Colors.white,
                        //shadowColor: Colors.greenAccent,
                        //elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: border_radius),
                        minimumSize: Size(20, 25), //////// HERE
                      ),
                      onPressed: () async {

                        Future<int> result = databaseHelper.insertCart(Cart(
                            id,
                            display_name,
                            image.toString(),
                            price.toString().replaceAll(".0", ".00"),
                            1
                          )
                        );

                        updateListView();

                        if (result != 0) {  // Success
                          showCustomSnackBar(context,'${display_name} - Added to cart', colorSuccess);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder:(context) => HomeScreen())
                          );

                        } else {  // Failure
                          showCustomSnackBar(context, 'Failed to add to cart', colorFailed);
                        }

                      },
                      child: Text('Add'),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder:(context) =>
                    DetailsScreen(
                        data: Product(
                            id: id,
                            name: name,
                            image: image,
                            price: price,
                            description: description,
                            qty: qty,
                            discount: discount,
                            volume: volume,
                            category_id: category_id
                        )
                    )
                )
            );

          },
        )
    );
  }
}