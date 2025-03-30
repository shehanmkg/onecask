import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/collection_item.dart';
import '../../models/user.dart';
import '../../models/distillery.dart';
import '../../models/whiskey.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'one_cask_collection.db';
  static const String _collectionTable = 'collection_items';
  static const String _userTable = 'user';
  static const String _distilleriesTable = 'distilleries';
  static const String _whiskeysTable = 'whiskeys';
  static const int _dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    print("Database path: $path");

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS $_whiskeysTable');

      await db.execute('''
        CREATE TABLE $_whiskeysTable (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          distillery TEXT,
          region TEXT,
          age INTEGER,
          abv REAL,
          caskType TEXT,
          bottled TEXT,
          price REAL,
          rating REAL,
          tastingNotes TEXT,
          limitedEdition INTEGER,
          inCollection INTEGER,
          purchaseDate TEXT,
          imageUrl TEXT
        )
      ''');

      print("Upgraded whiskeys table schema in database");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_collectionTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_userTable (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        displayName TEXT NOT NULL,
        email TEXT NOT NULL,
        joinDate TEXT,
        profileImage TEXT,
        preferences TEXT,
        stats TEXT,
        settings TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_distilleriesTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT,
        founded INTEGER,
        description TEXT,
        owner TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_whiskeysTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        distillery TEXT,
        region TEXT,
        age INTEGER,
        abv REAL,
        caskType TEXT,
        bottled TEXT,
        price REAL,
        rating REAL,
        tastingNotes TEXT,
        limitedEdition INTEGER,
        inCollection INTEGER,
        purchaseDate TEXT,
        imageUrl TEXT
      )
    ''');

    print("Database tables created.");
  }

  Future<void> upsertCollectionItems(List<CollectionItem> items) async {
    final db = await database;
    final batch = db.batch();

    for (var item in items) {
      batch.insert(
        _collectionTable,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print("Upserted ${items.length} items into database.");
  }

  Future<List<CollectionItem>> getCollectionItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_collectionTable);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return CollectionItem.fromMap(maps[i]);
    });
  }

  Future<void> clearCollectionItems() async {
    final db = await database;
    await db.delete(_collectionTable);
    print("Cleared all items from database table '$_collectionTable'.");
  }

  Future<void> upsertUser(User user) async {
    final db = await database;

    final Map<String, dynamic> userMap = {
      'id': user.id,
      'username': user.username,
      'displayName': user.displayName,
      'email': user.email,
      'joinDate': user.joinDate,
      'profileImage': user.profileImage,
      'preferences': jsonEncode(user.preferences.toJson()),
      'stats': jsonEncode(user.stats.toJson()),
      'settings': jsonEncode(user.settings.toJson()),
    };

    await db.insert(
      _userTable,
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("User upserted into database.");
  }

  Future<User?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_userTable);

    if (maps.isEmpty) {
      return null;
    }

    final userMap = maps.first;

    return User(
      id: userMap['id'] as String,
      username: userMap['username'] as String,
      displayName: userMap['displayName'] as String,
      email: userMap['email'] as String,
      joinDate: userMap['joinDate'] as String,
      profileImage: userMap['profileImage'] as String,
      preferences: UserPreferences.fromJson(jsonDecode(userMap['preferences'] as String)),
      stats: UserStats.fromJson(jsonDecode(userMap['stats'] as String)),
      settings: UserSettings.fromJson(jsonDecode(userMap['settings'] as String)),
    );
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete(_userTable);
    print("Cleared user from database table '$_userTable'.");
  }

  Future<void> upsertDistilleries(List<Distillery> distilleries) async {
    final db = await database;
    final batch = db.batch();

    for (var distillery in distilleries) {
      batch.insert(
        _distilleriesTable,
        distillery.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print("Upserted ${distilleries.length} distilleries into database.");
  }

  Future<List<Distillery>> getDistilleries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_distilleriesTable);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Distillery.fromMap(maps[i]);
    });
  }

  Future<void> clearDistilleries() async {
    final db = await database;
    await db.delete(_distilleriesTable);
    print("Cleared all distilleries from database table '$_distilleriesTable'.");
  }

  Future<void> upsertWhiskeys(List<Whiskey> whiskeys) async {
    final db = await database;
    final batch = db.batch();

    for (var whiskey in whiskeys) {
      final Map<String, dynamic> whiskyMap = {
        'id': whiskey.id,
        'name': whiskey.name,
        'description': whiskey.description,
        'distillery': whiskey.distillery,
        'region': whiskey.region,
        'age': whiskey.age,
        'abv': whiskey.abv,
        'caskType': whiskey.caskType,
        'bottled': whiskey.bottled,
        'price': whiskey.price,
        'rating': whiskey.rating,
        'tastingNotes': jsonEncode(whiskey.tastingNotes.toJson()),
        'limitedEdition': whiskey.limitedEdition ? 1 : 0,
        'inCollection': whiskey.inCollection ? 1 : 0,
        'purchaseDate': whiskey.purchaseDate,
        'imageUrl': whiskey.imageUrl,
      };

      batch.insert(
        _whiskeysTable,
        whiskyMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print("Upserted ${whiskeys.length} whiskeys into database.");
  }

  Future<List<Whiskey>> getWhiskeys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_whiskeysTable);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      final map = maps[i];

      final tastingNotesJson = jsonDecode(map['tastingNotes'] as String);

      return Whiskey(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        distillery: map['distillery'] as String,
        region: map['region'] as String,
        age: map['age'] as int,
        abv: map['abv'] as double,
        caskType: map['caskType'] as String,
        bottled: map['bottled'] as String,
        price: map['price'] as double,
        rating: map['rating'] as double,
        tastingNotes: TastingNotes.fromJson(tastingNotesJson),
        limitedEdition: (map['limitedEdition'] as int) == 1,
        inCollection: (map['inCollection'] as int) == 1,
        purchaseDate: map['purchaseDate'] as String,
        imageUrl: map['imageUrl'] as String,
      );
    });
  }

  Future<void> clearWhiskeys() async {
    final db = await database;
    await db.delete(_whiskeysTable);
    print("Cleared all whiskeys from database table '$_whiskeysTable'.");
  }
}
