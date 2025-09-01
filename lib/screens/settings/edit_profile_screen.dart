import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/data/const_inputDecoration.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/provider/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _emaleController;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  final db = DatabaseService();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emaleController = TextEditingController();

    db.getMyProfile().then((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile.firstName;
          _surnameController.text = profile.lastName;
          _emaleController.text = profile.email;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emaleController.dispose();
    super.dispose();
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      await db.updateProfile(_nameController.text, _nameController.text);
    }
  }

  void _showAddCompanyDialog() {
    final TextEditingController _codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Add company", style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _codeController,
            style: TextStyle(color: Colors.black),

            decoration: InputDecoration(
              labelText: "Enter your company code",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String code = _codeController.text;
                String? comapny = "";
                try{
                comapny = await db.getCompanyName(code);
                print(comapny);
                }
                catch(ex){
                   ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("BAD INPUT CODE")));
                }
                if (comapny == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("BAD INPUT CODE")));
                  return;
                }

                if (code.isNotEmpty) {
                  await db.updateCompanyProfile(false, true, code, comapny);
                  ref.invalidate(profileProvider);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      try {
        User? user = _auth.currentUser;

        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        if (_newPasswordController.text == _newPasswordController.text) {
          await user.updatePassword(_newPasswordController.text);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password changed successfully ✅")),
            );
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match ❌")),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  // Future<void> _resetPassword() async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user?.email != null) {
  //       await _auth.sendPasswordResetEmail(email: user!.email!);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Password reset email sent 📩")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EditProfile")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Personal Data",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.black),
                  decoration: inputDecoration("Name"),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _surnameController,
                  style: TextStyle(color: Colors.black),
                  decoration: inputDecoration("Surname"),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Surname is required'
                      : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _emaleController,
                  enabled: false,
                  decoration: const InputDecoration(
                    helperText: "The email address cannot be changed.",
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: inputDecoration("Old Password"),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Old password is required'
                      : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: inputDecoration("New Password"),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'New password is required'
                      : null,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _showAddCompanyDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "ADD COMPANY",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      _update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "CHANGE PASSWORD",
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
      ),
    );
  }
}
