import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/services/category_service.dart';

class EditCategoryScreen extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;

  const EditCategoryScreen({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isActive,
  });

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final CategoryService categoryService = CategoryService();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;
  late bool isActive;

  // "late" ginamit para ma initialize inside initState()
  // para malagay pre filled text or value
  // (e.g., TextEditingController(text: widget.name))

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    imageUrlController = TextEditingController(text: widget.imageUrl);
    isActive = widget.isActive;
  }

  // tatawaging si category_service.dart
  // para magamit yung updateCategory na nandun
  Future updateCategory() async {
    await categoryService.updateCategory(
      id: widget.id,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageUrlController.text.trim(),
      isActive: isActive,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Category Updated")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00164D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF00164D),
        foregroundColor: Colors.white,
        title: const Text("Edit Category"),
      ),

      body: Center(
        child: SingleChildScrollView(
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
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Description", style: TextStyle(color: Colors.white)),

              Container(
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
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
                child: TextField(
                  controller: imageUrlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              // Walang validation sa URL kasi I think
              // if ever may chance na wala pang image 
              // si user.

              const SizedBox(height: 20),

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

              const SizedBox(height: 35),

              SizedBox(
                width: 140,
                height: 38,
                child: ElevatedButton(
                  onPressed: updateCategory,
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
    );
  }
}
