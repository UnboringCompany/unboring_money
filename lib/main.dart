import 'package:flutter/material.dart';
import 'package:unboring_money/screens/my_accounts.dart';
import 'package:unboring_money/screens/my_budget.dart';
import 'package:unboring_money/screens/settings.dart';
import 'package:unboring_money/screens/stats.dart';
import 'screens/add_depense.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';
import 'package:unboring_money/widgets/transaction_list.dart';

void main() {
  runApp(const UnboringMoneyApp());
}

class UnboringMoneyApp extends StatelessWidget {
  const UnboringMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnboringMoney',
      theme: ThemeData(
        primaryColor: const Color(0xFF109186),
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add-expense': (context) => const AddExpensePage(initialTabIndex: 0),
        '/add-category': (context) => const AddExpensePage(initialTabIndex: 1),
        '/add-account': (context) => const AddExpensePage(initialTabIndex: 2),
        '/stats': (context) => StatsPage(),
        '/wallet': (context) => MyAccountsPage(),
        '/budget': (context) => MyBudgetPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final double budgetRestant = 1850.45;

  final List<Map<String, String>> transactions = [
    {'name': 'Carrefour', 'date': '04/10/2024', 'amount': '47,65€'},
    {'name': 'Auchan', 'date': '03/10/2024', 'amount': '47,65€'},
    {'name': 'Lideule', 'date': '02/10/2024', 'amount': '47,65€'},
    {'name': 'Action', 'date': '01/10/2024', 'amount': '47,65€'},
    {'name': 'H&M', 'date': '01/10/2024', 'amount': '47,65€'},
    {'name': 'Fnac', 'date': '01/10/2024', 'amount': '47,65€'},
  ];

  final List<Map<String, String>> upcommingTransactions = [
    {'name': 'EDF', 'date': '15/10/2024', 'amount': '47,65€'},
    {'name': 'Loyer', 'date': '15/10/2024', 'amount': '47,65€'},
  ];

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('UnboringMoney', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
      ),
      body: Column(
        children: [
          BudgetSection(budgetRestant: widget.budgetRestant),
          const SizedBox(height: 20),
          TransactionList(transactions: widget.transactions, upcomingTransactions: widget.upcommingTransactions),
        ],
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}

// Section du budget
class BudgetSection extends StatelessWidget {
  final double budgetRestant;

  const BudgetSection({super.key, required this.budgetRestant});
  
  String get daysLeft {
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysLeft = endOfMonth.day - now.day;
    return daysLeft.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, left: 24, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reste à dépenser pour les $daysLeft prochains jours',
            style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w300),
          ),
          Text(
            '${budgetRestant.toStringAsFixed(2)}€',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/budget');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF109186),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Mon budget', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}