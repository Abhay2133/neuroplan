import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/constants/colors.dart';
import 'package:neuroplan/services/project_service.dart';
import 'package:neuroplan/utils.dart';
import 'package:neuroplan/widgets/spinner.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>>? projectsData;

  @override
  void initState() {
    super.initState();

    fetchProjects();
  }

  void fetchProjects() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      alert(context, "User is not signed in !", title: "Error");
      return;
    }
    setState(() {
      isLoading = true;
    });
    ProjectService projectService = ProjectService(uid: uid);
    try {
      List<Map<String, dynamic>> data = await projectService.getAllProjects();
      setState(() {
        projectsData = data;
      });
    } catch (e) {
      alert(context, e.toString(), title: "Project Fetch error", copy: true);
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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          // color: Colors.amber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Projects",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Gap(16),
              Expanded(child: _projectsList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noDataState(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.red
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Projects Found",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Gap(16),
          ElevatedButton(
            onPressed: fetchProjects,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.restart_alt), Gap(8), Text("Reload")],
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectsList(BuildContext context) {
    if (isLoading) return Center(child: Spinner(radius: 20));
    if (projectsData == null) return _noDataState(context);
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: List<Widget>.generate(projectsData!.length, (index) {
          String name = projectsData![index]["name"];
          int noOfTasks = projectsData![index]["tasks"].length;
          String goal = projectsData![index]['goal'];
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: AppColor.translucentDark),
              ),
              padding: EdgeInsets.all(16),
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Gap(4),
                  Text(goal, style: Theme.of(context).textTheme.bodySmall,),
                  Gap(8),
                  Row(children: [Flexible(flex: 1, child: Text("$noOfTasks Steps"))]),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
