import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:unboring_money/models/Depense.dart';
import 'package:unboring_money/models/Categorie.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/widgets/charts/ToggleButtonSelectionChart.dart';
import 'package:unboring_money/widgets/charts/BarChart.dart';

class StatsPage extends StatefulWidget {
  final int initialTabIndex;

  const StatsPage({super.key, required this.initialTabIndex});

  @override
  // ignore: library_private_types_in_public_api
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<Map<String, dynamic>> _depenses = [];
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
    fetchDepenses();
  }

  Future<void> fetchDepenses() async {
    final dbHelper = DatabaseHelper();
    List<Depense> depenses = await dbHelper.getDepenses();
    List<Categorie> categories = await dbHelper.getCategories();
    List<Compte> comptes = await dbHelper.getComptes();

    // Map des catégories et des comptes
    Map<int, String> categorieMap = {
      for (var cat in categories) cat.id!: cat.nom
    };
    Map<int, String> compteMap = {
      for (var compte in comptes) compte.id!: compte.nom
    };

    // Transformation des données en incluant la date formatée
    List<Map<String, dynamic>> allDepenseData = depenses.map((depense) {
      return {
        'valeur': depense.montant,
        'legende': depense.date, // Formatage de la date
        'categorieId': depense.categorieId,
        'categorie': categorieMap[depense.categorieId] ?? 'Inconnue',
        'compte': compteMap[depense.compteId] ?? 'Inconnu',
        'titre': depense.titre,
        'date': depense.date, // Inclure également la date brute si besoin
      };
    }).toList();

    // Filtrage initial si nécessaire
    List<Map<String, dynamic>> filteredDepenseData = filterData(
      data: allDepenseData,
      filterBy: null, // Par défaut, pas de filtre appliqué
      filterId: null,
    );

    setState(() {
      _depenses = filteredDepenseData;
    });
  }

  List<Map<String, dynamic>> filterData({
    required List<Map<String, dynamic>> data,
    String? filterBy, // 'compte' pour filtrer par compte
    int? filterId, // ID de compte à filtrer
  }) {
    // Étape 1 : Filtrer par compte si spécifié
    List<Map<String, dynamic>> filteredData = data.where((entry) {
      if (filterBy == 'compte' && entry['compte'] != filterId) {
        print("false");
        return false;
      }
      return true;
    }).toList();

    // Étape 2 : Transformer les données pour ne conserver que 'valeur', 'couleur' et 'legende'
    List<Map<String, dynamic>> resultData = filteredData.map((entry) {
      // print(entry);
      return {
        'valeur': entry['valeur'],
        'order' : entry['categorieId'],
        'legende': entry['legende'], // Utilisation de la date formatée comme légende
      };
    }).toList();

    return resultData;
  }

  // Fonction helper pour attribuer une couleur à une catégorie (simple exemple)
  Color getColorForCategory(int categorieId) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
    ];
    return colors[
        categorieId % colors.length]; // Distribution cyclique des couleurs
  }

  // Fonction pour gérer le changement de sélection dans le ToggleButton
  void _onSelectionChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: const Text('Statistiques',
            style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ToggleButtonSelectionChart(
                onSelectionChanged: _onSelectionChanged,
                initialIndex: _selectedTab,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 60.0), // Add a margin at the bottom
              child: _selectedTab == 0
                  ? BarChart(
                      // Afficher BarChart seulement si selectedTab est 0
                      data: _depenses,
                      // selectedTab: _selectedTab,
                    )
                  : const Center(
                      // TODO : Remplacer par un chart rond après
                      child: Text(
                        "No data available", // Message à afficher sinon
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}
