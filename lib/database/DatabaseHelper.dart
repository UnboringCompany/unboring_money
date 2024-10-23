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

  Future<double> getSpentForAccount(int compte) async {
    // Date actuelle
    DateTime today = DateTime.now();

    // Début du mois en cours
    DateTime startOfMonth = DateTime(today.year, today.month, 1);

    // Récupérer la base de données
    final db = await database;

    // Récupérer les dépenses du compte pour le mois en cours
    final List<Map<String, dynamic>> maps = await db.query(
      'Depenses',
      where: 'compteId = ? AND date >= ? AND date <= ?',
      whereArgs: [compte, startOfMonth.toIso8601String(), today.toIso8601String()]
    );

    // Calculer la somme des montants des dépenses
    double totalSpent = 0.0;
    for (var map in maps) {
      totalSpent += map['montant'];
    }

    // Retourner le montant total
    return totalSpent;
  }

  Future<double> getSpentForCategory(int category) async {
    // Date actuelle
    DateTime today = DateTime.now();

    // Début du mois en cours
    DateTime startOfMonth = DateTime(today.year, today.month, 1);

    // Récupérer la base de données
    final db = await database;

    // Récupérer les dépenses du compte pour le mois en cours
    final List<Map<String, dynamic>> maps = await db.query(
      'Depenses',
      where: 'categorieId = ? AND date >= ? AND date <= ?',
      whereArgs: [category, startOfMonth.toIso8601String(), today.toIso8601String()]
    );

    // Calculer la somme des montants des dépenses
    double totalSpent = 0.0;
    for (var map in maps) {
      totalSpent += map['montant'];
    }

    // Retourner le montant total
    return totalSpent;
  }

  Future<List<Depense>> getDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Depenses');

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

  Future<List<Depense>> getMoisDepenses() async {
    final db = await database;

    // Date actuelle
    DateTime today = DateTime.now();
    
    // Début du mois en cours
    DateTime startOfMonth = DateTime(today.year, today.month, 1);
    
    // Récupérer les transactions entre le début du mois et aujourd'hui
    final List<Map<String, dynamic>> maps = await db.query(
      'Depenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startOfMonth.toIso8601String(), today.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Depense(
        id: maps[i]['id'],
        titre: maps[i]['titre'],
        montant: maps[i]['montant'],
        date: maps[i]['date'],
        compteId: maps[i]['compteId'],
        categorieId: maps[i]['categorieId'],
        recurrence: maps[i]['recurrence'],
      );
    });
  }

  Future<List<Depense>> getDepensesAVenir() async {
    final db = await database;

    // Date actuelle
    DateTime today = DateTime.now();
    
    // Date du lendemain
    DateTime tomorrow = today.add(const Duration(days: 1));
    
    // Fin du mois en cours
    DateTime endOfMonth = DateTime(today.year, today.month + 1, 0); // Le 0ème jour du mois prochain donne le dernier jour du mois en cours
    
    // Récupérer les transactions à partir de demain jusqu'à la fin du mois
    final List<Map<String, dynamic>> maps = await db.query(
      'Depenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [tomorrow.toIso8601String(), endOfMonth.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Depense(
        id: maps[i]['id'],
        titre: maps[i]['titre'],
        montant: maps[i]['montant'],
        date: maps[i]['date'],
        compteId: maps[i]['compteId'],
        categorieId: maps[i]['categorieId'],
        recurrence: maps[i]['recurrence'],
      );
    });
  }

  Future<int> getTotalLimit() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categories');

    // Calculer la somme des montants des dépenses
    int limit = 0;
    for (var map in maps) {
      // Vérifie si 'limite' est présent et non nul
      if (map['limite'] != null) {
        // Convertir la valeur en int, même si c'est un double
        limit += (map['limite'] as num).toInt();
      }
    }
    return limit;
  }

  Future<double> getSpentMonth() async {
    // Date actuelle
    DateTime today = DateTime.now();

    // Début du mois en cours
    DateTime startOfMonth = DateTime(today.year, today.month, 1);

    // Récupérer la base de données
    final db = await database;

    // Récupérer les dépenses du compte pour le mois en cours
    final List<Map<String, dynamic>> maps = await db.query(
      'Depenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startOfMonth.toIso8601String(), today.toIso8601String()]
    );

    // Calculer la somme des montants des dépenses
    double totalSpent = 0.0;
    for (var map in maps) {
      totalSpent += map['montant'];
    }
    // Retourner le montant total
    return totalSpent;
  }
}
