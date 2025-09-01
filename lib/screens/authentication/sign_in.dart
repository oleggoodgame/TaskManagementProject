import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management/data/const_inputDecoration.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:project_management/screens/authentication/start_sign_up.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        ref.invalidate(profileProvider);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        ref.watch(userDataProvider.notifier).clear();
        Navigator.of(context).popUntil((route) => route.isFirst);

      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: inputDecoration("Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: inputDecoration("Password"),
                style: TextStyle(color: Colors.black),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _signIn(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const StartSignUp(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
