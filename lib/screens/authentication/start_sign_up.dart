import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/data/const_inputDecoration.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:project_management/screens/authentication/sign_up.dart';

class StartSignUp extends ConsumerStatefulWidget {
  const StartSignUp({super.key});

  @override
  ConsumerState<StartSignUp> createState() => _StartSignUpScreenState();
}

class _StartSignUpScreenState extends ConsumerState<StartSignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      if (ref.read(userDataProvider.notifier).fifi()) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const SignUpScreen(),
          ),
        );
      }
    }
  }

  void _showAgreement() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Agreement"),
        content: const Text(
          "You are a good person, and you understand that this is not a real program.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final userNotifier = ref.read(userDataProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Personal Data",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Colors.black),

                decoration: inputDecoration("Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Name is required';
                  return null;
                },
                onChanged: (val) => userNotifier.setName(val),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _surnameController,
                style: TextStyle(color: Colors.black),

                decoration: inputDecoration("Surname"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Surname is required';
                  return null;
                },
                onChanged: (val) => userNotifier.setSurname(val),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Switch(
                    value: userData.read,
                    onChanged: (value) => userNotifier.setRead(value),
                  ),
                  TextButton(
                    onPressed: _showAgreement,
                    child: const Text(
                      "You have read the agreement.",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
