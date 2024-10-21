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
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.pie_chart,
              color: Color(0xFF109186),
            ),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/stats') {
                Navigator.pushReplacementNamed(context, '/stats');
              }
            },
          ),
          const SizedBox(width: 40), // Space for the floating action button
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF109186),
            ),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/wallet') {
                Navigator.pushReplacementNamed(context, '/wallet');
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF109186),
            ),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/settings') {
                Navigator.pushReplacementNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
    );
  }
}