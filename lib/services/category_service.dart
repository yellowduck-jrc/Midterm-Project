import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCategories() {
    return firestore.collection("categories").snapshots();
  }

  Future addCategory({
    required String name,
    required String description,
    required String imageUrl,
    required bool isActive,
  }) async {
    await firestore.collection("categories").add({
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future updateCategory({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required bool isActive,
  }) async {
    await firestore.collection("categories").doc(id).update({
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "isActive": isActive,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future deleteCategory(String id) async {
    await firestore.collection("categories").doc(id).delete();
  }
}
