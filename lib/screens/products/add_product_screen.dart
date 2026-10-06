import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductService productService = ProductService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String selectedCategoryId = "";

  bool isActive = true;

  Future createProduct() async {
    await productService.addProduct(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: int.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      categoryId: selectedCategoryId,
      imageUrl: imageUrlController.text.trim(),
      isActive: isActive,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Product Created")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00164D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF00164D),
        foregroundColor: Colors.white,
        title: const Text("Create Product"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // declare GlobalKey<FormState> in your State class
            child: Column(
              children: [
                const Text(
                  "Product Name",
                  style: TextStyle(color: Colors.white),
                ),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Product name is required";
                      }
                      if (value.length < 3) {
                        return "Product name must be at least 3 characters";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Description",
                  style: TextStyle(color: Colors.white),
                ),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description is required";
                      }
                      if (value.length < 10) {
                        return "Description must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Price", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Price is required";
                      }
                      final price = int.tryParse(value);
                      if (price == null || price <= 0) {
                        return "Enter a valid positive price";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Quantity", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Quantity is required";
                      }
                      final qty = int.tryParse(value);
                      if (qty == null || qty < 1) {
                        return "Quantity must be at least 1";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Category", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("categories")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var categories = snapshot.data!.docs;
                      return DropdownButtonFormField<String>(
                        initialValue: selectedCategoryId.isEmpty
                            ? null
                            : selectedCategoryId,
                        dropdownColor: const Color(0xFF00164D),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(
                              category["name"],
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryId = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a category";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Image URL", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: imageUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),

                // Walang validation sa URL kasi I think
                // if ever may chance na wala pang image 
                // si user.

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: SwitchListTile(
                    title: const Text(
                      "Active",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 140,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: createProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8CC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Create", style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
