import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(
      String userId, String name, String profession, String email) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'profession': profession,
        'email': email,
      });
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }

  // Add other Firestore database operations as needed
}
