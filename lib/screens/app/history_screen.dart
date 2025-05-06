import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/utils.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyData = [
    {
      "id": "1",
      "prompt":
          "I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.",
      "created_at": "2025-05-05T17:52:02.149Z"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              "Prompt History",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap(16),
            Expanded(child: _list(context)),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(historyData[0]['prompt'], style: Theme.of(context).textTheme.bodyLarge,),
                Gap(4),
                Text(timeElapsed(historyData[0]['created_at']), style: Theme.of(context).textTheme.labelMedium,),
              ],
            ),
          ),
        );
      },
    );
  }
}
