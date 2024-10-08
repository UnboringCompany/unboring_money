import 'package:flutter/material.dart';

class FloatingAdd extends StatelessWidget{
  
  final VoidCallback onPressed;
  const FloatingAdd({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF109186),
        child: const Icon(Icons.add, color: Color(0xFFF0FDFA)),
      );
  }
}