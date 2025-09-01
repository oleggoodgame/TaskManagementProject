import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/screens/authentication/sign_in.dart';
import 'package:project_management/screens/home_screen.dart';

class Authenticate extends ConsumerWidget {
  const Authenticate({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FirebaseAuth.instance.signOut();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return const HomeScreen();
        }

        return SignInScreen();
      },
    );
  }
}
