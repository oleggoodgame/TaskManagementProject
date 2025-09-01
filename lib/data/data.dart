import 'package:flutter/material.dart';
import 'package:project_management/models/profile.dart';

const List<ProfileAction> profileActions = [
  ProfileAction(
    "Edit Profile",
    Icon(Icons.person),
    TypeProfileAction.EditProfile,
  ),
  ProfileAction("Settings", Icon(Icons.settings), TypeProfileAction.Settings),
  ProfileAction("Feedback", Icon(Icons.feedback), TypeProfileAction.FeedBack),
  ProfileAction("Sign out", Icon(Icons.sensor_door_outlined), TypeProfileAction.SignOut),
  ProfileAction("Delete Profile", Icon(Icons.delete), TypeProfileAction.Delete),
];
