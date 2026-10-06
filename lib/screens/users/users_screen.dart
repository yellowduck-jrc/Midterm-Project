import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/screens/products/products_screen.dart';
import 'package:flutter_ecommerce_crud/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_crud/screens/categories/categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_crud/services/auth_service.dart';
import 'package:flutter_ecommerce_crud/services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService userService = UserService();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF00164D),
        title: const Text(
          "User",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.delete_outline, color: Colors.white),
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
                    searchText = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF00164D)),
                  hintText: "Search user...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .snapshots(),
              builder: (context, retrieve) {
                if (retrieve.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var users = retrieve.data!.docs;
                var filteredUsers = users.where((user) {
                  String name = user["name"].toString().toLowerCase();
                  String email = user["email"].toString().toLowerCase();

                  return name.contains(searchText) ||
                      email.contains(searchText);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      "No User Found!",
                      style: TextStyle(color: Color(0xFF00164D), fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var userToPrint = filteredUsers[index];
                    return UserCard(
                      uid: userToPrint.id,
                      name: userToPrint["name"],
                      email: userToPrint["email"],
                      role: userToPrint["role"],
                      onDelete: () =>
                          userService.deleteUser(context, userToPrint.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
