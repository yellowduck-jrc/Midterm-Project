import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/screens/categories/edit_category_screen.dart';
import 'package:flutter_ecommerce_crud/screens/products/products_screen.dart';

class CategoryCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFB8B8C9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF07134D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),

              // pag may laman si imageUrl : pag walang Url Icon.category lalabas
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl)
                  : Icon(Icons.category, color: Colors.white, size: 45),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xFF07134D),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(description),

                const SizedBox(height: 4),

                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40A6BC),
                          foregroundColor: Colors.white, // Color ng mga nasa taas ng button
                          padding: const EdgeInsets.symmetric(horizontal: 10), // spacing sa gedli kanan tas kaliwa
                        ),
                        child: Text(
                          "See All Products",
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategoryScreen(
                                id: id,
                                name: name,
                                description: description,
                                imageUrl: imageUrl,
                                isActive: isActive,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 17,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF40A6BC),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 17,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF40A6BC),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
