import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/cart/widgets/cart_viewholder.dart';
import 'package:watadrop/common/database_helper.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/location_services.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/widgets/address_widget.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

final cartScaffoldKey = GlobalKey<ScaffoldState>();

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  late String _currentAddress;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Cart> myData = <Cart>[];
  double total_price = 0.00, delivery_price = 20.00;

  bool _isLoading = true;

  final _controller = TextEditingController();

  final plugin = PaystackPlugin();

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await databaseHelper.getCartList();
    setState(() {
      myData = data;
      _isLoading = false;
      count = myData.length;
      if (count > 0){
        for (int x = 0; x < count; x++){
          total_price = total_price + double.parse(myData[x].price) + delivery_price;
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
    getCurrentAddress().then((value) => _controller.text = value);

    plugin.initialize(
        publicKey: paystack_public_key);
  }

  @override
  void dispose() {
    _controller.dispose();
    //_getCurrentPosition();
    super.dispose();
  }

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
                gotoHomeScreen();
              },
            ),
            //centerTitle: true,
            title: Text("CART"),
            elevation: 0,

            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 4),
                  child: GestureDetector(
                    child: Icon(Icons.delete_forever, color: colorSecondary,),
                    onTap: () {
                      for (int a = 0; a < count; a++){
                        Future<int> result = databaseHelper.deleteCart(myData[a].id);

                        if (result != 0) {  // Success
                          updateListView();
                        }
                      }
                      count = 0;
                      showCustomSnackBar(context,'Cart has been cleared.', colorSuccess);
                      updateListView();
                      Navigator.pop(context);
                      },
                  )
              )
            ]
        ),
        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : myData.isEmpty
            ? const Center(child: Text("Your cart is empty. Please add something.", style: TextStyle(color: Colors.white, fontSize: 16),))
            : ListView.builder(
            itemCount: myData.length,
            itemBuilder: (context, index) =>
                SingleChildScrollView(
                  child: showCardWidget(myData, context, index, databaseHelper, updateListView),
                )
        ),
        bottomSheet: BottomSheet(

            builder: (context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  child:  Padding(padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          TextField(
                              readOnly: true,
                              controller: _controller,
                              onChanged: (value) {
                                _currentAddress = value.trim();
                              },
                              cursorColor: colorAccent,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: border_radius
                                ),
                                labelText: 'Delivery Location',
                                hintText: 'Search address',
                                isDense: true,                      // Added this
                                contentPadding: text_field_padding,
                              ),
                              maxLines: 5, // <-- SEE HERE
                              minLines: 1,
                              onTap: (){
                                showAddressPickerDialog(context, _controller);
                              }
                          ),

                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Icon(Icons.location_pin, color: colorSecondary,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Subtotal:'),
                                  Text('Delivery Fee:'),
                                  Text('Total:'),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('R ${total_price.toStringAsFixed(2)}'),
                                  Text('R ${delivery_price.toStringAsFixed(2)}'),
                                  Text('R ${total_price+delivery_price}0'),

                                ],
                              )

                            ],
                          )
                        ],
                      )
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {

                      if (_controller.text.isNotEmpty){
                        String? cart_message="";
                        var order_id = DateTime.now().millisecondsSinceEpoch.toString();

                        Charge charge = Charge()
                          ..amount = int.parse((total_price+delivery_price).toStringAsFixed(0))*100
                          ..reference = order_id
                          ..currency = "ZAR"
                        // or ..accessCode = _getAccessCodeFrmInitialization()
                          ..email = user!.email;
                        CheckoutResponse response = await plugin.checkout(
                          context ,
                          method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
                          charge: charge,
                        );

                        if (response.status){
                          for (int a = 0; a < count; a++){
                            if (myData[a].name.toString().isNotEmpty){
                              cart_message = "$cart_message\n${myData[a].qty.toString()} ${myData[a].name.toString()}";
                            }

                          }

                          fireStore.collection('orders').doc(order_id).set({
                            'name': user!.displayName,
                            'address': _controller.text,
                            'amount': total_price.toStringAsFixed(2),
                            'datetime' : DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString(),
                            'user_id': user!.uid,
                            'status': 0,
                            'order_id': order_id,
                            'cart': cart_message
                          });

                          for (int a = 0; a < count; a++){
                            Future<int> result = databaseHelper.deleteCart(myData[a].id);

                            if (result != 0) {  // Success
                              updateListView();
                            }
                          }

                          showCustomSnackBar(context, "Order Placed Successfully", colorSuccess);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder:(context) => HomeScreen())
                          );
                        } else {
                          showCustomSnackBar(context, response.message, colorFailed);
                        }

                      } else{
                        showCustomSnackBar(context, "Please set address.", colorFailed);
                      }

                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50), // NEW
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),backgroundColor: colorSuccess
                    ),
                    child: Text('CHECKOUT', style: TextStyle(color: Colors.white),)
                ),
              ],
            );
          }, onClosing: () {
              Navigator.pop(context);
            },
        ),
    );
  }

  void gotoHomeScreen() {
    Navigator.pop(context);
  }
  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Cart>> cartListFuture = databaseHelper.getCartList();
      cartListFuture.then((noteList) {
        this.myData = noteList;
        //count = noteList.length;
      });
    });
  }


}





