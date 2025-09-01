import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/data/data.dart';
import 'package:project_management/models/profile.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/screens/authentication/authenticate.dart';
import 'package:project_management/screens/settings/edit_profile_screen.dart';
import 'package:project_management/screens/settings/settings_screen.dart';
import 'package:project_management/widgets/image_input.dart';
import 'package:project_management/widgets/more_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _deleteAccount() async {
    final TextEditingController passwordController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No user signed in")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Confirm account deletion",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(labelText: "Enter your password"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text.trim();

                try {
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: password,
                  );
                  await user.reauthenticateWithCredential(cred);

                  await user.delete();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Authenticate(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final profileNotifier = ref.watch(profileProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text("No profile found"));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageInput(
                      onPickImage: (image) async {
                        final imageRef = FirebaseStorage.instance
                            .ref('images')
                            .child(profile.email);

                        final uploadTask = await imageRef.putFile(image);
                        final imageUrl = await uploadTask.ref.getDownloadURL();

                        await profileNotifier.updateImage(imageUrl);
                        await profileNotifier.refreshProfile();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.ImageUrl != null
                            ? NetworkImage(profile.ImageUrl!)
                            : null,
                        child: profile.ImageUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                  ],
                ),

                Text(
                  "${profile.firstName} ${profile.lastName}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Email: ${profile.email}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "CompanyName: ${profile.company ?? "No company"}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "Employer: ${profile.employer}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Employee: ${profile.employee}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: profileActions.length,
                    itemBuilder: (context, index) {
                      final item = profileActions[index];
                      return InkWell(
                        onTap: () => _showOnTap(item.type),
                        child: MoreCard(icon: item.icon, title: item.title),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  _showOnTap(TypeProfileAction type) async {
    if (type == TypeProfileAction.EditProfile) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
    } else if (type == TypeProfileAction.SignOut) {
      await FirebaseAuth.instance.signOut();
    } else if (type == TypeProfileAction.Settings) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
    } else if (type == TypeProfileAction.FeedBack) {
      _launchUrl("https://github.com/oleggoodgame");
    } else if (type == TypeProfileAction.Delete) {
      await _deleteAccount();
    }
  }

  _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
