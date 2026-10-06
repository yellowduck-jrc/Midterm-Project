import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/screens/users/users_screen.dart';
import 'package:flutter_ecommerce_crud/services/user_service.dart';

class EditUserScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String role;

  const EditUserScreen({
    super.key,
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserService userService = UserService();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;

  // "late" ginamit para ma initialize inside initState()
  // para malagay pre filled text or value
  // (e.g., TextEditingController(text: widget.name))

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    roleController = TextEditingController(text: widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00164D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF00164D),
        foregroundColor: Colors.white,
        title: const Text("Edit User"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // Sa firestore dataset lang mapapalitan
              children: [
                const Text("Name", style: TextStyle(color: Colors.white)),

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Email", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Role", style: TextStyle(color: Colors.white)),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextFormField(
                    controller: roleController,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Role is required";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: 140,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () async {
                      // tatawaging si user_service.dart
                      // para magamit yung updateUser na nandun
                      if (_formKey.currentState!.validate()) {
                        await userService.updateUser(
                          widget.uid,
                          nameController.text.trim(),
                          emailController.text.trim(),
                          roleController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User Updated")),
                        );

                        // Ginamit ang pushAndRemoveUntil imbes na .push lang kasi
                        // kapag .push, may stack siya bawat navigation ipapatong lang
                        // yung bagong page sa ibabaw ng current page.
                        // Kung gusto mong mag-redirect sa LoginPage na wala nang back button,
                        // pushAndRemoveUntil ang gamit para ma-clear yung navigation stack
                        // at hindi na makabalik sa previous page.

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsersScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8CC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Update", style: TextStyle(fontSize: 13)),
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
