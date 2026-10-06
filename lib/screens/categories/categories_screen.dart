import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/services/auth_service.dart';
import 'package:flutter_ecommerce_crud/screens/products/products_screen.dart';
import 'package:flutter_ecommerce_crud/screens/users/users_screen.dart';
import 'package:flutter_ecommerce_crud/screens/categories/add_category_screen.dart';
import 'package:flutter_ecommerce_crud/widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String searchText = "";

  Future deleteCategory(BuildContext context, String id, String name) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text("Are you sure you want to delete $name?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF00164D),
        title: const Text(
          "Category",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.shopping_cart_rounded, color: Colors.white),
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
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            decoration: const BoxDecoration(color: Color(0xFF080F4D)),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFF00164D)),
                      hintText: "Search category...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var categories = snapshot.data!.docs;

                var filteredCategories = categories.where((category) {
                  var data = category.data() as Map<String, dynamic>;

                  String name = data["name"]?.toString().toLowerCase() ?? "";

                  return name.contains(searchText);
                }).toList();

                return Column(
                  children: [
                    const SizedBox(height: 15),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          var category = filteredCategories[index];

                          var data = category.data() as Map<String, dynamic>;

                          return CategoryCard(
                            id: category.id,
                            name: data["name"],
                            description: data["description"],
                            imageUrl: data["imageUrl"],
                            isActive: data["isActive"],
                            onDelete: () {
                              deleteCategory(
                                context,
                                category.id,
                                data["name"]?.toString() ?? "",
                              );
                            },
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddCategoryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Category"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF080F4D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
