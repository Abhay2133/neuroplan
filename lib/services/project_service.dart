import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectService {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProjectService({required this.uid});

  CollectionReference<Map<String, dynamic>> get _projectCollection =>
      _firestore.collection('users').doc(uid).collection('projects');

  /// Create a new project with auto-generated ID
  Future<Map<String, dynamic>> createProject(
    Map<String, dynamic> projectData,
  ) async {
    final docRef = await _projectCollection.add(projectData);
    return {'id': docRef.id, ...projectData};
  }

  /// Get a specific project by project ID
  Future<Map<String, dynamic>?> getProject(String projectId) async {
    final doc = await _projectCollection.doc(projectId).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  /// Get all projects for the user
  Future<List<Map<String, dynamic>>> getAllProjects() async {
    final snapshot = await _projectCollection.get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }
}
