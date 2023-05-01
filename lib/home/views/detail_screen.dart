import 'package:flutter/material.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/models/product.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';


class DetailsScreen extends StatefulWidget {
  final Product data;

  const DetailsScreen({required this.data});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  TextEditingController qtyController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  var subtotal;

  @override
  Widget build(BuildContext context) {
    String display_name = "${widget.data.name} (${widget.data.volume}ml)";

    if (widget.data.qty>1){
      display_name = "${widget.data.name} (${widget.data.volume}ml x ${widget.data.qty})";

    }
    if (widget.data.volume >999){
      display_name = "${widget.data.name} (${widget.data.volume/1000}L x ${widget.data.qty})";
    }

    int item_qty = 1;

    qtyController.text = item_qty.toString();
    totalController.text = widget.data.price.toString()+".00";


    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        foregroundColor: colorSecondary,
        title: Text(
          "$display_name",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8),
              Hero(
                tag: widget.data.id,
                child: CircleAvatar(
                  backgroundColor: colorPrimary,
                  backgroundImage: NetworkImage(
                    widget.data.image,
                  ),
                  radius: MediaQuery.of(context).size.width / 4,
                ),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Price".toUpperCase()),
                  Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        "R${widget.data.price}.00",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorSecondary
                        ),
                      ))
                ],
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Quantity".toUpperCase()),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(onPressed: (){

                        if (item_qty != 1) {
                          item_qty--;
                          qtyController.text = item_qty.toString();
                          subtotal = widget.data.price*item_qty;

                          totalController.text = subtotal.toString()+'.00';

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
                        if (item_qty != 5){
                          item_qty++;
                          qtyController.text = item_qty.toString();
                          subtotal = widget.data.price*item_qty;
                          totalController.text = subtotal.toString()+'.00';

                        }
                      }, icon: const Icon(Icons.add_box_sharp, color: Colors.lightBlue)),


                    ],
                  ),
                ],
              ),
              Visibility(
                  visible: widget.data.discount==0?false:true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Discount"),
                      Text(
                        "- R${widget.data.discount}.00",
                        style: TextStyle(
                            color: colorSecondary
                        ),
                      ),
                    ],
                  )
              ),

              SizedBox(height: 32),
              Text(
                "Description".toUpperCase()+"\n${widget.data.description.replaceAll("*", "\n")}",
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total Price".toUpperCase()),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      readOnly: true,
                      controller: totalController,
                      //decoration: InputDecoration(labelText: 'Enter Number'),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 48,
        width: double.infinity,
        color: colorAccent,
        child: ElevatedButton(
          child: Text(
            "ADD TO CART",
            style: TextStyle(
                color: colorPrimary
            ),
          ),
          onPressed: () {
            Future<int> result = databaseHelper.insertCart(Cart(
                widget.data.id,
                display_name,
                widget.data.image.toString(),
                widget.data.price.toString(),
                item_qty
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
        ),
      ),
    );
  }
}