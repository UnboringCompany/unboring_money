import 'package:flutter/material.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/widgets/accounts_list.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';

class MyAccountsPage extends StatefulWidget {
  @override
  _MyAccountsPageState createState() => _MyAccountsPageState();
}

class _MyAccountsPageState extends State<MyAccountsPage> {

  Map<Compte, double> _comptes = {};
  
  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    final dbHelper = DatabaseHelper();
    final comptes = await dbHelper.getComptes();
    for (var compte in comptes) {
          final spent = await dbHelper.getSpentForAccount(compte.id!);
          _comptes[compte] = spent;
    }
    print(_comptes);
    setState(() {
      _comptes = _comptes;
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
        title: const Text('Mes comptes', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //Pop up to add a new account
              Navigator.of(context).pushReplacementNamed('/add-account');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AccountsList(accountsList: _comptes),
        ],
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}