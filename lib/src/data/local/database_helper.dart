import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/collection_item.dart'; // Import the model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'one_cask_collection.db';
  static const String _tableName = 'collection_items';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    print("Database path: $path"); // Log the database path for debugging

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // Add if schema changes later
    );
  }

  // Create the table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT
      )
    ''');
    print("Database table '$_tableName' created.");
  }

  // Insert or update a list of items (Upsert)
  Future<void> upsertCollectionItems(List<CollectionItem> items) async {
    final db = await database;
    final batch = db.batch();

    for (var item in items) {
      batch.insert(
        _tableName,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace if ID exists
      );
    }
    await batch.commit(noResult: true);
    print("Upserted ${items.length} items into database.");
  }

  // Get all items from the database
  Future<List<CollectionItem>> getCollectionItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return CollectionItem.fromMap(maps[i]);
    });
  }

  // Clear all items from the table
  Future<void> clearCollectionItems() async {
    final db = await database;
    await db.delete(_tableName);
    print("Cleared all items from database table '$_tableName'.");
  }

  // Close the database (optional, typically handled by sqflite)
  // Future<void> close() async {
  //   final db = await database;
  //   db.close();
  //   _database = null;
  // }
}
