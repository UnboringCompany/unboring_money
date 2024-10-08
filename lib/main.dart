import 'package:flutter/material.dart';

import 'add_depense.dart';

void main() {
  runApp(UnboringMoneyApp());
}

class UnboringMoneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnboringMoney',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(), // Page principale
    );
  }
}

// Page principale
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des widgets pour chaque écran de la barre de navigation
  final List<Widget> _pages = [
    MainScreen(),  // Ecran principal
    Center(child: Text('Statistiques')), // Placeholder pour la section "Statistiques"
    Center(child: Text('Compte')),       // Placeholder pour une autre section
    Center(child: Text('Paramètres')),   // Placeholder pour les paramètres
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Lorsqu'on clique sur le bouton Plus, on navigue vers la page d'ajout d'une dépense
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddExpensePage()),
      );
    } else {
      // Sinon, on change simplement l'index de la page
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[100],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), // Bouton Plus
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}

// Écran principal simulé (là où tu as la liste des dépenses)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text('UnboringMoney'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Reste à dépenser pour les 22 prochains jours',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '1850,45€',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('Dépenses récentes')),
              Expanded(child: Text('À venir')),
            ],
          ),
          // Exemples de dépenses (remplace par tes données)
          ListTile(title: Text('Carrefour'), subtitle: Text('47,65€')),
          ListTile(title: Text('Auchan'), subtitle: Text('47,65€')),
          ListTile(title: Text('Lideule'), subtitle: Text('47,65€')),
          // Ajoute d'autres widgets pour l'interface principale
        ],
      ),
    );
  }
}
