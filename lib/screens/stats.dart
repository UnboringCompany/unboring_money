import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:graphic/graphic.dart';
import 'package:unboring_money/models/Depense.dart';
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
  List<Depense> _depenses = [];
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
    fetchDepenses();
  }

  Future<void> fetchDepenses() async {
    final dbHelper = DatabaseHelper();
    _depenses = await dbHelper.getDepenses();
    setState(() {
      _depenses = _depenses;
    });
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
                ? BarChart( // Afficher BarChart seulement si selectedTab est 0
                    depenses: _depenses,
                    selectedTab: _selectedTab,
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
