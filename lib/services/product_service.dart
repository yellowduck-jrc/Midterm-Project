import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProducts() {
    return firestore.collection("products").snapshots();
  }

  Future addProduct({
    required String name,
    required String description,
    required int price,
    required int quantity,
    required String categoryId,
    required String imageUrl,
    required bool isActive,
  }) async {
    await firestore.collection("products").add({
      "name": name,
      "description": description,
      "price": price,
      "quantity": quantity,
      "categoryId": categoryId,
      "imageUrl": imageUrl,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future updateProduct({
    required String id,
    required String name,
    required String description,
    required int price,
    required int quantity,
    required String categoryId,
    required String imageUrl,
    required bool isActive,
  }) async {
    await firestore.collection("products").doc(id).update({
      "name": name,
      "description": description,
      "price": price,
      "quantity": quantity,
      "categoryId": categoryId,
      "imageUrl": imageUrl,
      "isActive": isActive,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future deleteProduct(String id) async {
    await firestore.collection("products").doc(id).delete();
  }
}
