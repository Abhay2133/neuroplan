import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scaffold(body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Text("Projects", style: Theme.of(context).textTheme.headlineMedium,)
          ],),
        ),)
      ),
    );
  }
}
