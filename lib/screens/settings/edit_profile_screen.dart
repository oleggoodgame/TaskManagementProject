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
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _emailController;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = DatabaseService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();

    db.getMyProfile().then((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile.firstName;
          _surnameController.text = profile.lastName;
          _emailController.text = profile.email;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_profileFormKey.currentState!.validate()) {
      await db.updateProfile(_nameController.text, _surnameController.text);
      ref.invalidate(profileProvider);
      Navigator.of(context).pop();
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPasswordController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully ✅")),
        );
        _oldPasswordController.clear();
        _newPasswordController.clear();
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      if (mounted) setState(() => _loading = false);
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
                try {
                  comapny = await db.getCompanyName(code);
                  print(comapny);
                } catch (ex) {
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

  Future<void> _addPasswordForGoogleUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final password = _newPasswordController.text;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    setState(() => _loading = true);
    try {
      await user.linkWithCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password added successfully ✅")),
        );
        _newPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'provider-already-linked') {
        message = "Account already has this method.";
      } else if (e.code == 'credential-already-in-use') {
        message = "This email is already used by another account.";
      } else {
        message = e.message ?? "Unknown error";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get hasPassword {
    return _auth.currentUser?.providerData.any(
          (p) => p.providerId == "password",
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
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
            Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Data",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecoration("Name"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _surnameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecoration("Surname"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Surname is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    enabled: false,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      helperText: "Email cannot be changed.",
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateProfile();
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
                ],
              ),
            ),

            const SizedBox(height: 50),

            Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (hasPassword)
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: inputDecoration("Old Password"),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Old password is required'
                          : null,
                    ),
                  if (hasPassword) const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: inputDecoration(
                      hasPassword ? "New Password" : "Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password is required (min 6 chars)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  hasPassword
                      ? SizedBox(
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
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    hasPassword
                                        ? "CHANGE PASSWORD"
                                        : "ADD PASSWORD",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : hasPassword
                                ? _addPasswordForGoogleUser
                                : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    hasPassword
                                        ? "CHANGE PASSWORD"
                                        : "ADD PASSWORD",
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
          ],
        ),
      ),
    );
  }
}
