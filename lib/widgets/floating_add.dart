import 'package:flutter/material.dart';

class FloatingAdd extends StatelessWidget{

  const FloatingAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          if (ModalRoute.of(context)?.settings.name != '/add-expense') {
            Navigator.pushNamed(context, '/add-expense');
          }
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF109186),
        child: const Icon(Icons.add, color: Color(0xFFF0FDFA)),
      );
  }
}