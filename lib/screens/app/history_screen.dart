import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Projects", style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

