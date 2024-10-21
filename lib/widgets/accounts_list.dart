import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/account_item.dart';
import 'package:unboring_money/widgets/category_item.dart';

class AccountsList extends StatefulWidget {
  
  const AccountsList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  bool showUpcomingTransactions = false;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        color: const Color(0xFFCDFAF0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: [1,2,3].length,
                itemBuilder: (context, index) {
                  return const AccountItem(name: 'Compte PayPal', spent: 2000, icon: Icons.account_balance_wallet);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}