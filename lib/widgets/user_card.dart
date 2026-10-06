import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_crud/screens/users/edit_user_screen.dart';

class UserCard extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String role;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.onDelete,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon, name/email, role
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, size: 40, color: Color(0xFF00164D)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00164D),
                        ),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF00164D),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF00164D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Buttons row
            Row(
              children: [
                _buildButton(
                  label: "Edit",
                  icon: Icons.edit,
                  color: const Color(0xFF00164D),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(
                          uid: widget.uid,
                          name: widget.name,
                          email: widget.email,
                          role: widget.role,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                _buildButton(
                  label: "Delete",
                  icon: Icons.delete,
                  color: const Color(0xFF00164D),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 0,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }
}
