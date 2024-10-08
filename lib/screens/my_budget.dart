import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';

class MyBudgetPage extends StatefulWidget {
  @override
  _MyBudgetPageState createState() => _MyBudgetPageState();
}

class _MyBudgetPageState extends State<MyBudgetPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('UnboringMoney', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Contenu de la page
        ],
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}