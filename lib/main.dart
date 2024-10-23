import 'package:flutter/material.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:unboring_money/models/Depense.dart';
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

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  List<Depense> _moisDepenses = [];
  List<Depense> _aVenirDepenses = [];
  int _limit = 0;
  double _spent = 0.0;
  

  @override
  void initState() {
    super.initState();
    fetchMoisDepenses();
    fetchDepensesAVenir();
    fetchLimitSpent();
  }

  Future<void> fetchLimitSpent() async {
    final dbHelper = DatabaseHelper();
    _limit = await dbHelper.getTotalLimit();
    _spent = await dbHelper.getSpentMonth();
    setState(() {
      _limit = _limit;
      _spent = _spent;
    });
  }

  Future<void> fetchDepensesAVenir() async {
    final dbHelper = DatabaseHelper();
    _moisDepenses = await dbHelper.getMoisDepenses();
    print(_moisDepenses);
    setState(() {
      _moisDepenses = _moisDepenses;
    });
  }

  Future<void> fetchMoisDepenses() async {
    final dbHelper = DatabaseHelper();
    _aVenirDepenses = await dbHelper.getDepensesAVenir();
    print(_aVenirDepenses);
    setState(() {
      _aVenirDepenses = _aVenirDepenses;
    });
  }

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
          BudgetSection(budgetRestant: _limit.toDouble() - _spent),
          const SizedBox(height: 20),
          TransactionList(transactions: _moisDepenses, upcomingTransactions: _aVenirDepenses),
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
              Navigator.pushReplacementNamed(context, '/budget');
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