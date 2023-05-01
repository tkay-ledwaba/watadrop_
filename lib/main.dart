
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/common/check_connection.dart';
import 'package:watadrop/common/database_helper.dart';
import 'package:watadrop/common/style.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/landing_screen.dart';
import 'package:watadrop/splash_screen.dart';

Future main() async {
  var devices = ["3ECB68428182FB9CD5CF1CBBBA6077E2", "9D3D19CEC5EAA5F0A7E088D30AD26520",
    "78C00043BDB6E1AEB9A4D1F26EEE852B", "20E7CB371CB24450A9CF874D4613E6EB"];
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initDatabase();

  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: devices
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(MyApp());
}

Future<void> initDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), db_name),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return  db.execute('CREATE TABLE '
          '$dbTable'
          '($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$colName TEXT, '
          '$colImage TEXT, '
          '$colQuantity INTEGER, '
          '$colPrice TEXT)'
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: db_version,
  );

  database.then((value) => print(value));


}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: colorAccent,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      //'/': (context) => MainPage(),
      '/home': (context) => HomeScreen(),
    },
    //home: ,
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    check_connection(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: colorAccent,
              foregroundColor: colorPrimary//here you can give the text color
          ),
          primarySwatch: colorAccent,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LandingScreen();
            }
          },
        )
    );
  }
}
