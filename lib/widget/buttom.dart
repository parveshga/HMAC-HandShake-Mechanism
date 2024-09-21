import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Start Scan'),
    );
  }
}
