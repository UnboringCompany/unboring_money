import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String date;
  final String amount;

  const TransactionItem({super.key, required this.name, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        tileColor: const Color(0xFFF0FDFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: const Icon(Icons.shopping_cart, color: Color(0xFF109186)),
        title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
        trailing: Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}