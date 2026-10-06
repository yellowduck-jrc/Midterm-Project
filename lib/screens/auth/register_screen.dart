import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_crud/models/user_model.dart';
import 'package:flutter_ecommerce_crud/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var usersTo = FirebaseFirestore.instance.collection("users");

  Future _firebaseAccountRegistration() async {
    try { // tinuro din to, nasa video sa teams
      var registerClient = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      String uid = registerClient.user!.uid;

      UserModel newUser = UserModel(
        uid,
        _nameController.text.trim(),
        _emailController.text.trim(),
        "customer",
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.userMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registered Successfully!"),
          duration: Duration(seconds: 3),
        ),
      );

      // Ginamit ang pushAndRemoveUntil imbes na .push lang kasi
      // kapag .push, may stack siya bawat navigation ipapatong lang
      // yung bagong page sa ibabaw ng current page.
      // Kung gusto mong mag-redirect sa LoginPage na wala nang back button,
      // pushAndRemoveUntil ang gamit para ma-clear yung navigation stack
      // at hindi na makabalik sa previous page.

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), duration: Duration(seconds: 3)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00164D),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://scontent.fmnl40-1.fna.fbcdn.net/v/t1.15752-9/825261302_1784401322869376_6206129879984018963_n.png?_nc_cat=110&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=9f807c&_nc_eui2=AeFJUE8nfzMP_x7w3nJH3b620r2lE2EE7HTSvaUTYQTsdPgI8iHqOMdbQZVls8h5oh-nNN4s-UGINsPoS56Oemak&_nc_ohc=CbC17jaA6V8Q7kNvwG2zn12&_nc_oc=AdpzZ42LYlVUOyIAwFieCFcxivkLjUtfVgqp3FTb3sCYbIvA9DWy9615e5oez-JyY7A&_nc_zt=23&_nc_ht=scontent.fmnl40-1.fna&_nc_ss=7a2a8&oh=03_Q7cD6gGEZb-aQ33DxPL1eVBPwo7TDKPcx9949BHT4j9Co1ya4Q&oe=6AE00A32",
                  height: 220,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const CircularProgressIndicator();
                  },

                  // callback function to ng Image.network
                  // para pag hindi nag load yung Url may 
                  // mare-return tulad dito yung Icons.broken_image
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 120,
                    );
                  },
                ),

                Text(
                  "REGISTRATION:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 50),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    if (value.length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value == null || !value.contains("@")
                      ? "Enter a valid email"
                      : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.length < 6
                      ? "Password must be at least 6 characters"
                      : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _firebaseAccountRegistration();
                      }
                    },
                    child: Text("Register"),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                        (route) => false,
                      );
                    },
                    child: Text("Back"),
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
