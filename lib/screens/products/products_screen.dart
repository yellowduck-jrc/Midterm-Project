import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_crud/screens/categories/categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_crud/services/auth_service.dart';
import 'package:flutter_ecommerce_crud/screens/users/users_screen.dart';
import 'package:flutter_ecommerce_crud/screens/products/add_product_screen.dart';
import 'package:flutter_ecommerce_crud/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String? selectedCategoryId;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00164D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Food",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF00164D)),
              child: const Text(
                "Menu",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Users"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Categories"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Products"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsScreen()),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00164D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                    (route) => false,
                  );
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF00164D),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF00164D)),
                  hintText: "Search product...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00164D),
                  ),
                ),
                const SizedBox(width: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("categories")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        height: 25,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    var categories = snapshot.data!.docs;

                    return Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00164D)),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCategoryId,
                        underline: const SizedBox(),
                        hint: const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF00164D),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF00164D),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(
                              category["name"],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF00164D),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryId = value;
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedCategoryId == null
                  ? FirebaseFirestore.instance
                        .collection("products")
                        .snapshots()
                  : FirebaseFirestore.instance
                        .collection("products")
                        .where("categoryId", isEqualTo: selectedCategoryId)
                        .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!.docs;

                // Apply search filter
                var filteredProducts = products.where((product) {
                  final name = product["name"].toString().toLowerCase();
                  final description = product["description"]
                      .toString()
                      .toLowerCase();
                  return name.contains(searchQuery) ||
                      description.contains(searchQuery);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Products Found!",
                      style: TextStyle(color: Color(0xFF00164D)),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    var product = filteredProducts[index];
                    return ProductCard(
                      id: product.id,
                      name: product["name"],
                      description: product["description"],
                      price: product["price"],
                      quantity: product["quantity"],
                      categoryId: product["categoryId"],
                      imageUrl: product["imageUrl"],
                      isActive: product["isActive"],
                      onDelete: () {
                        FirebaseFirestore.instance
                            .collection("products")
                            .doc(product.id)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Mag nanavigate to papuntang AddProductScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Color(0xFF00164D), size: 18),
                label: const Text(
                  "Add Product",
                  style: TextStyle(
                    color: Color(0xFF00164D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00164D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
