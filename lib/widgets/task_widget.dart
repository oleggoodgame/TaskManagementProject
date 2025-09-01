import 'package:flutter/material.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/models/profile.dart';
import 'package:project_management/screens/task_detail_screen.dart';

class TaskWidget extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final Color color;
  final String userId;
  final db = DatabaseService();
  TaskWidget(
    this.name,
    this.description,
    this.color,
    this.userId,
    this.id, {
    super.key,
  });
  String shortenText(String text, {int maxLength = 40}) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(id, name, color, description),
          ),
        );
      },
      child: FutureBuilder<Profile?>(
        future: db.getProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return const Text("No profile found");
          }

          final profile = snapshot.data!;
          return SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 8,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shortenText(name),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(fontSize: 18),
                        ),
                        Text(
                          shortenText(description, maxLength: 90),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            profile.ImageUrl != null &&
                                profile.ImageUrl!.isNotEmpty
                            ? NetworkImage(profile.ImageUrl!)
                            : null,
                        child:
                            (profile.ImageUrl == null ||
                                profile.ImageUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 20)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${profile.firstName} ${profile.lastName}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
