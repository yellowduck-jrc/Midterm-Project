import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_crud/screens/auth/login_screen.dart';
import 'package:flutter_ecommerce_crud/screens/users/users_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  // same lang to ng ginawa ni sir guys sa video sa teams

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, auth) {
          if (auth.hasData) {
            return UsersScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
