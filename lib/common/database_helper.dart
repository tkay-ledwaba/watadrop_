import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:watadrop/cart/models/cart.dart';


String db_name = 'cart.db';
int db_version = 1;

String dbTable = 'cart_table';
String colId = 'id';
String colName = 'name';
String colImage = 'image';
String colQuantity = 'qty';
String colPrice = 'price';

class DatabaseHelper {

  static DatabaseHelper? _databaseHelper;    // Singleton DatabaseHelper
  static Database? _database;                // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/'+db_name;

    // Open/create the database at a given path
    var database = await openDatabase(path, version: db_version, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE '
        '$dbTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colName TEXT, '
        '$colImage TEXT, '
        '$colQuantity INTEGER, '
        '$colPrice TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getCartMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(dbTable, orderBy: '$colQuantity ASC');
    return result;
  }

  // Insert Operation: Insert a object to database
  Future<int> insertCart(Cart cart) async {
    Database db = await this.database;
    var result = await db.insert(dbTable, cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateCart(Cart cart) async {
    var db = await this.database;
    var result = await db.update(dbTable, cart.toMap(), where: '$colId = ?', whereArgs: [cart.id]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteCart(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $dbTable WHERE $colId = $id');
    return result;
  }

  // Get number of objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $dbTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Cart>> getCartList() async {

    var cartMapList = await getCartMapList(); // Get 'Map List' from database
    int count = cartMapList.length;         // Count the number of map entries in db table

    List<Cart> cartList = <Cart>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      cartList.add(Cart.fromMapObject(cartMapList[i]));
    }

    return cartList;
  }


}







