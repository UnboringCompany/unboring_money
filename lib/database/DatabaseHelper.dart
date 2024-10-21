import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:unboring_money/models/Categorie.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/models/Depense.dart';

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
  //Future<int> insertDepense(Map<String, dynamic> row) async {
    //final db = await database;
    //return await db.insert('Depense', row);
  //}

  Future<void> insertDepense(Depense depense) async {
    final db = await database; // Obtention d’une référence sur la BD
    // Insertion dans la table Users
    await db.insert(
      ' Categories',
      depense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      // `conflictAlgorithm` permet de détecter que le tuple inséré existe déjà
      // Ici, on spécifie qu’en pareil cas on remplace la donnée qui existait déjà
    );
    print("new categorie");
  }

  // Insert into Categorie table
  //Future<int> insertCategorie(Map<String, dynamic> row) async {
    //final db = await database;
    //return await db.insert('Categorie', row);
  //}

  Future<void> insertCategorie(Categorie categorie) async {
    final db = await database; // Obtention d’une référence sur la BD
    // Insertion dans la table Users
    await db.insert(
      ' Categories',
      categorie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      // `conflictAlgorithm` permet de détecter que le tuple inséré existe déjà
      // Ici, on spécifie qu’en pareil cas on remplace la donnée qui existait déjà
    );
    print("new categorie");
  }

  // Insert into Compte table
  //Future<int> insertCompte(Map<String, dynamic> row) async {
  //final db = await database;
  //return await db.insert('Compte', row);
  //}

  Future<void> insertCompte(Compte compte) async {
    final db = await database; // Obtention d’une référence sur la BD
    // Insertion dans la table Users
    await db.insert(
      ' Comptes',
      compte.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      // `conflictAlgorithm` permet de détecter que le tuple inséré existe déjà
      // Ici, on spécifie qu’en pareil cas on remplace la donnée qui existait déjà
    );
    print("new account");
  }

  Future<List<Categorie>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categorie');
    return List.generate(maps.length, (i) {
      return Categorie(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        description: '',
      );
    });
  }

  Future<List<Compte>> getComptes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categorie');
    return List.generate(maps.length, (i) {
      return Compte(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
      );
    });
  }
}
