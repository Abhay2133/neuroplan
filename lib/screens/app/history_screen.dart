import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/utils.dart';
import 'package:neuroplan/widgets/spinner.dart';

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
      "created_at": "2025-05-05T17:52:02.149Z",
    },
  ];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadHistory();
  }

  void loadHistory() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return alert(context, "User is not logged in", title: "Error");
    }
    final promptsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('prompts');
    try {
      setState(() {
        isLoading = true;
      });
      final snapshot =
          await promptsRef
              .orderBy('timestamp', descending: true)
              .limit(10)
              .get();
      setState(() {
        historyData = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      dlog(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
            Expanded(
              child: isLoading ? Center(child: Spinner()) : _list(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.separated(
      itemCount: historyData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  historyData[index]['prompt'],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Gap(4),
                Text(
                  timeAgoFromTimestamp(historyData[index]['timestamp']),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Gap(8);
      },
    );
  }
}
