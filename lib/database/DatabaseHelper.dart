import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'unboringmoney.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables here
        await db.execute('''
          CREATE TABLE Depense (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT,
            type TEXT,
            montant REAL,
            date TEXT,
            compteId INTEGER,
            recurrence TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Categorie (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Compte (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT
          )
        ''');
      },
    );
  }

  // Insert into Depense table
  Future<int> insertDepense(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Depense', row);
  }

  // Insert into Categorie table
  Future<int> insertCategorie(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Categorie', row);
  }

  // Insert into Compte table
  Future<int> insertCompte(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Compte', row);
  }
}
