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
          CREATE TABLE Depenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT,
            categorieId INTEGER,
            montant REAL,
            date TEXT,
            compteId INTEGER,
            recurrence TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            limite INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE Comptes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDepense(Depense depense) async {
    final db = await database; // Obtention d’une référence sur la BD
    // Insertion dans la table Users
    await db.insert(
      ' Depenses',
      depense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      // `conflictAlgorithm` permet de détecter que le tuple inséré existe déjà
      // Ici, on spécifie qu’en pareil cas on remplace la donnée qui existait déjà
    );
  }

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
  }

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
  }

  Future<List<Categorie>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categories');
    return List.generate(maps.length, (i) {
      return Categorie(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        limite: maps[i]['limite'],
      );
    });
  }

  Future<List<Compte>> getComptes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Comptes');

    return List.generate(maps.length, (i) {
      return Compte(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
      );
    });
  }

  Future<List<Depense>> getDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Depenses');

    print(maps);

    return List.generate(maps.length, (i) {
      return Depense(
        id: maps[i]['id'],
        titre: maps[i]['titre'],
        montant: maps[i]['montant'],
        date: maps[i]['date'],
        compteId: maps[i]['compteId'],
        categorieId: maps[i]['categorieId'],
      );
    });
  }
}
