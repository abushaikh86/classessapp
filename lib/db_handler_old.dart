// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pluspoint/util/constants.dart' as constants;

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler.internal();

  factory DatabaseHandler() => _instance;

  static Database? _db;

  Future<dynamic> login(String mobile, String password) async {
    print('Login function is executing');
    print(mobile);
    // var dbClient = await db;

    // try {
    //   return await dbClient.query("admission",
    //       where: "contact_no = ? AND password = ?",
    //       whereArgs: [mobile, password],
    //       limit: 1);
    // } catch (e) {
    //   // Handle any database-related errors
    //   print("Database error: $e");
    //   return null;
    // }
  }

  DatabaseHandler.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '${constants.apiBaseURL}');

    try {
      // Open the database. Can also create the database here if it doesn't exist.
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      print("Error opening database: $e");
      rethrow; // Rethrow the exception for further handling.
    }
  }

  void _onCreate(Database db, int newVersion) async {
    // Create tables and define their columns
    await db.execute(
        "CREATE TABLE IF NOT EXISTS admission (admission_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NULL, fathername TEXT NULL, contact_no TEXT NULL, email TEXT NULL, contact_no TEXT NULL)");
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    Database dbClient = await db;
    return await dbClient.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    Database dbClient = await db;
    return await dbClient.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> values, String where,
      List<dynamic> whereArgs) async {
    Database dbClient = await db;
    return await dbClient.update(table, values,
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    Database dbClient = await db;
    return await dbClient.delete(table, where: where, whereArgs: whereArgs);
  }

  // Future close() async {
  //   Database dbClient = await db;
  //   dbClient.close();
  // }
}
