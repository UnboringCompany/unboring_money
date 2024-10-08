import 'package:flutter/material.dart';

class UnboringNavBar extends StatelessWidget {
  const UnboringNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: const Color(0xFFF0FDFA),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Color(0xFF109186),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.pie_chart_outline,
                color: Color(0xFF109186),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/stats');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.account_balance_wallet,
                color: Color(0xFF109186),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/wallet');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color(0xFF109186),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      );
  }
}