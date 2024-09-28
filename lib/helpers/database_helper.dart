import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "EventsDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'events';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnDate = 'date';
  static const columnReminder = 'reminder';
  static const columnBackgroundImage = 'backgroundImage';
  static const columnColor = 'color';
  static const columnLocation = 'location'; // No SQL comment here

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create it if it doesn't exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''  
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnReminder TEXT,
        $columnBackgroundImage TEXT,
        $columnColor INTEGER,
        $columnLocation TEXT
      )
    ''');
  }

  // Insert a row in the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Get all rows from the database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Get a row by id
  Future<Map<String, dynamic>?> queryRowById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first; // Return the first match
    }
    return null; // Return null if no match found
  }

  // Update a row in the database
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId]; // Extract the id from the row
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete a row from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
