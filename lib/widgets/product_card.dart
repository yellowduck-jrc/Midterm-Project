import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/screens/products/edit_product_screen.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String categoryId;
  final String imageUrl;
  final bool isActive;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.imageUrl,
    required this.isActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product image
            Container(
              height: 90,
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              // pag may laman si imageUrl : pag walang Url Icon.category lalabas
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl) : const Icon(Icons.image, size: 50, color: Color(0xFF00164D),),
            ),

            const SizedBox(width: 15),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00164D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00164D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "₱${price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00164D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductScreen(
                                id: id,
                                name: name,
                                description: description,
                                price: price,
                                quantity: quantity,
                                categoryId: categoryId,
                                imageUrl: imageUrl,
                                isActive: isActive,
                              ),
                            ),
                          );
                        },

                        icon: const Icon(Icons.edit, size: 16),

                        label: const Text(
                          "Edit Product ",
                          style: TextStyle(fontSize: 13),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8CC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                "Are you sure you want to delete this product?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop(); // close dialog
                                    onDelete(); // call ProductService.deleteProduct
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Product deleted successfully",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFF00164D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
