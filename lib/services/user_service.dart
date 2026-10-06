import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() {
    return firestore.collection("users").snapshots();
  }

  Future deleteUser(BuildContext context, String uid) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await firestore.collection("users").doc(uid).delete();
    }
  }

  Future updateUser(String uid, String name, String email, String role) async {
    await firestore.collection("users").doc(uid).update({
      "name": name,
      "email": email,
      "role": role,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
