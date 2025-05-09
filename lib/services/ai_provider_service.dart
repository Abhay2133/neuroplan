// This service is used to manage the ai provider settings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiProviderService {
  static final AiProviderService _instance = AiProviderService._internal();
  factory AiProviderService() => _instance;
  AiProviderService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _providerNames = ['groq', 'chatgpt', 'gemini'];

  /// Update the API key of an AI provider
  Future<void> updateApiKey(String provider, String apiKey) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || !_providerNames.contains(provider)) return;

    final ref = _firestore.doc('/users/$uid/ai_providers/$provider');
    await ref.set({
      'name': provider,
      'api_key': apiKey,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Get the API key of an AI provider
  Future<String?> getApiKey(String provider) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || !_providerNames.contains(provider)) return null;

    final ref = _firestore.doc('/users/$uid/ai_providers/$provider');
    final snapshot = await ref.get();
    return snapshot.data()?['api_key'];
  }

  /// Set selected AI provider
  Future<void> setSelectedProvider(String provider) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || !_providerNames.contains(provider)) return;

    final userDoc = _firestore.collection('users').doc(uid);
    await userDoc.set({'selected_provider': provider}, SetOptions(merge: true));
  }

  /// Get the selected AI provider's info (returns {name, api_key, updated_at})
  Future<String?> getSelectedProvider() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final selected = userDoc.data()?['selected_provider'];

    return selected;
  }
}
