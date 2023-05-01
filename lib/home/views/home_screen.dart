import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:watadrop/Account/views/account_screen.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/cart/views/cart_screen.dart';
import 'package:watadrop/common/database_helper.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/models/product.dart';
import 'package:watadrop/orders/views/orders_screen.dart';
import 'package:watadrop/widgets/banner_ad_widget.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

DatabaseHelper databaseHelper = DatabaseHelper();
List<Cart> cartList = <Cart>[];
//Cart cart;
int count = 0;

void updateListView() {

  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  dbFuture.then((database) {

    Future<List<Cart>> noteListFuture = databaseHelper.getCartList();
    noteListFuture.then((noteList) {
      cartList = noteList;
      count = noteList.length;
    });
  });
}



class _HomeScreenState  extends State<HomeScreen> {


  late String name, lastname, phone, email, address, profile;

  List<String> dishCategories = [
    'Products',
    'Refill',
    'Subscriptions',
    'Services'
  ];

  int _active = 0;

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnitId = "ca-app-pub-3940256099942544/6300978111";

  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(
            onAdLoaded: (ad){
              isAdLoaded = true;
              print("Add is loaded");
            },
            onAdFailedToLoad: (ad,error){
              ad.dispose();
              print(error);
            }
        ),
        request: AdRequest()
    );
    bannerAd.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
    getUser();
    initBannerAd();

  }
  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    initBannerAd();
    final data = await databaseHelper.getCartList();
    setState(() {
      cartList = data;
      _isLoading = false;
      count = cartList.length;
    });
  }

  void getUser(){
    if (user!.displayName.toString().isEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return AccountScreen();
      }));
    }
    print(user!.displayName);
  }

  @override
  Widget build(BuildContext context) {

    if (cartList == null) {
      cartList = <Cart>[];
      updateListView();
    }

    int id = 0;

    return  Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorPrimary,
        title: Image.asset(
          'assets/images/logo.png',
          scale: 2,
          width: 100,
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 0.0, top: 0),
              child: GestureDetector(
                child: Badge(
                  badgeColor: colorAccent,
                  showBadge:(count == 0) ? false : true,
                  position: BadgePosition.topStart(top:4, start:12),
                  badgeContent: Text(count.toString(), style: TextStyle(color: colorPrimary),),
                  child: Icon(Icons.shopping_cart, color: colorSecondary,),
                ),
                onTap: () {
                  if(count == 0){
                    showCustomSnackBar(context, "Your cart is empty, please add something.", colorSecondary);
                  }else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartScreen()));
                  }
                },
              )
          ),
          Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: PopupMenuButton(
                // add icon, by default "3 dot" icon
                  icon: Icon(Icons.menu, color: colorSecondary,),
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("My Account"),
                      ),

                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Orders"),
                      ),

                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("Settings"),
                      ),
                    ];
                  },
                  onSelected:(value){
                    if(value == 0){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AccountScreen()));

                    }else if(value == 1){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrdersScreen()));

                    }else if(value == 2){
                      print("Logout menu is selected.");
                    }
                  }
              )
          )
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 32,
              child: ListView.builder(
                itemCount: dishCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) => Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _active = i;
                        print(_active);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: i == _active ? colorAccent : null,
                        borderRadius: border_radius,
                      ),
                      child: Text(
                        "${dishCategories[i].toUpperCase()}",
                        style: TextStyle(
                          color: i == _active ? colorPrimary : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 590,
              child: StreamBuilder<QuerySnapshot>(
                ///
                stream: fireStore
                    .collection('menu')
                    .orderBy('volume', descending: false)
                    .snapshots(),

                ///flutter aysnc snapshot
                builder: (context, snapshot) {
                  List<Product> product = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlue,
                      ),
                    );
                  }
                  final todoLists = snapshot.data!.docs;

                  for (var todoList in todoLists) {
                    id++;
                    final name = (todoList.data() as dynamic)['name'];
                    final description = (todoList.data() as dynamic)['description'];
                    final volume = (todoList.data() as dynamic)['volume'];
                    final image = (todoList.data() as dynamic)['image'];
                    final price = (todoList.data() as dynamic)['price'];
                    final qty = (todoList.data() as dynamic)['qty'];
                    final discount = (todoList.data() as dynamic)['discount'];
                    final category_id = (todoList.data() as dynamic)['category_id'];

                    if (_active == category_id){
                      final messageWidget = Product(
                          id: id,
                          name: '$name',
                          volume: volume,
                          image: '$image',
                          qty: qty,
                          price: price,
                          discount: discount,
                          description: '$description',
                          category_id: category_id
                        //cartList: cartList
                      );

                      product.add(messageWidget);
                    }
                  }

                  return GridView(  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //crossAxisSpacing: 10.0,
                    //mainAxisSpacing: 10,
                  ),
                      children: product);
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: loadBannerAdWidget(bannerAd,isAdLoaded),
    
    );
    }
}
