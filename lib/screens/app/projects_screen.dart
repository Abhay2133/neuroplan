import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Projects", style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
