import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/toggle_button.dart';
import 'package:unboring_money/widgets/transaction_item.dart';

class TransactionList extends StatefulWidget {
  final List transactions;
  final List upcomingTransactions;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.upcomingTransactions,
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool showUpcomingTransactions = false;

  @override
  Widget build(BuildContext context) {
    List currentTransactions = showUpcomingTransactions
        ? widget.upcomingTransactions
        : widget.transactions;

    return Expanded(
      child: Container(
        color: const Color(0xFFCDFAF0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            ToggleButton(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 36,
              toggleBackgroundColor: const Color(0xFFF0FDFA),
              toggleBorderColor: Colors.transparent,
              toggleColor: const Color(0xFF109186),
              activeTextColor: Colors.black,
              inactiveTextColor: Colors.black,
              leftDescription: "Récentes",
              rightDescription: "A venir",
              onLeftToggleActive: () {
                setState(() {
                  showUpcomingTransactions = false;
                });
              },
              onRightToggleActive: () {
                setState(() {
                  showUpcomingTransactions = true;
                });
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: currentTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    name: currentTransactions[index].titre!,
                    date: currentTransactions[index].date!,
                    amount: currentTransactions[index].montant!.toString(),
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