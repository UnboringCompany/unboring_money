import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/category_list.dart';
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
      extendBody: true,
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: const Text('Mon budget', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //Pop up to add a new budget
              Navigator.of(context).pushNamed('/add-category');
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          BudgetSection(budgetRestant: 1850.45, monthlyBudget: 4200.00),
          SizedBox(height: 20),
          CategoryList(),
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
  final double monthlyBudget;

  const BudgetSection({super.key, required this.budgetRestant, required this.monthlyBudget});
  
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
          // Barre de progression
          Container(
            padding: const EdgeInsets.only(right: 10),
            width: double.infinity,
            height: 30,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: LinearProgressIndicator(
                value: (monthlyBudget-budgetRestant) / monthlyBudget,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF109186)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
          padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('0€', style: TextStyle(fontSize: 14, color: Colors.black54)),
              Text('${monthlyBudget.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF109186),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Dépensé jusqu\'à maintenant : ',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text('${(monthlyBudget-budgetRestant).toStringAsFixed(2)}€', style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}