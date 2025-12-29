import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProfileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  return doc.data() ?? {};
});
