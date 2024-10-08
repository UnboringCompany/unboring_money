import 'package:flutter/material.dart';

void main() {
  runApp(UnboringMoneyApp());
}

class UnboringMoneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnboringMoney',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final double budgetRestant = 1850.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Couleur d'arrière-plan similaire
      appBar: AppBar(
        title: Text('UnboringMoney'),
        backgroundColor: Colors.teal[100],
        elevation: 0,
      ),
      body: Column(
        children: [
          BudgetSection(budgetRestant: budgetRestant),
          TransactionList(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// Section du budget
class BudgetSection extends StatelessWidget {
  final double budgetRestant;

  BudgetSection({required this.budgetRestant});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[100],
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Reste à dépenser pour les 22 prochains jours',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 8),
          Text(
            '${budgetRestant.toStringAsFixed(2)}€',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('Mon budget'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Liste des transactions récentes
class TransactionList extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {'name': 'Carrefour', 'date': '04/10/2024', 'amount': '47,65€'},
    {'name': 'Auchan', 'date': '03/10/2024', 'amount': '47,65€'},
    {'name': 'Lideule', 'date': '02/10/2024', 'amount': '47,65€'},
    {'name': 'Action', 'date': '01/10/2024', 'amount': '47,65€'},
    {'name': 'H&M', 'date': '01/10/2024', 'amount': '47,65€'},
    {'name': 'Fnac', 'date': '01/10/2024', 'amount': '47,65€'},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.teal[200],
        child: Column(
          children: [
            ToggleButtonsSection(),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    name: transactions[index]['name']!,
                    date: transactions[index]['date']!,
                    amount: transactions[index]['amount']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Élément de transaction individuel
class TransactionItem extends StatelessWidget {
  final String name;
  final String date;
  final String amount;

  TransactionItem({required this.name, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(date),
        trailing: Text(amount),
      ),
    );
  }
}

// Section des onglets "Récentes" et "A venir"
class ToggleButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Récentes'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('A venir'),
          ),
        ],
        isSelected: [true, false], // L'onglet "Récentes" est activé par défaut
        onPressed: (index) {},
        color: Colors.black54,
        selectedColor: Colors.teal[700],
        fillColor: Colors.teal[300],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// Barre de navigation inférieure
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.teal[100],
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
          icon: Icon(Icons.add_circle_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
      ],
    );
  }
}
