import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/services/category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final CategoryService categoryService = CategoryService();

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  bool isActive = true;

  Future createCategory() async {
    await categoryService.addCategory(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageUrlController.text.trim(),
      isActive: isActive,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Category Created")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00164D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF00164D),
        foregroundColor: Colors.white,
        title: const Text("Create Category"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Category Name",
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
                        return "Category name is required";
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
                      return null;
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createCategory();
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
