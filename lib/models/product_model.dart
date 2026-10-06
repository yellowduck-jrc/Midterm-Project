import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String uid;
  String name;
  String description;
  int price;
  int quantity;
  String categoryId;
  String imageUrl;
  bool isActive;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  ProductModel(
    this.uid,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.categoryId,
    this.imageUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, dynamic> productMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'price': price,
      'quantity':quantity,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
