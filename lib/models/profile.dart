import 'package:flutter/widgets.dart';

class Profile {
  String firstName;
  String lastName;
  String email;
  String? company;
  String? idCompany;
  String? ImageUrl;
  bool employee;
  bool employer;
  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.ImageUrl,
    required this.idCompany,
    required this.company,
    required this.employee,
    required this.employer,
  });
  Profile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    String? company,
    String? idCompany,

    bool? employee,
    bool? employer,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      ImageUrl: imageUrl ?? this.ImageUrl,
      idCompany: idCompany ?? this.idCompany,
      company: company ?? this.company,
      employee: employee ?? this.employee,
      employer: employer ?? this.employer,
    );
  }
}

enum TypeProfileAction { EditProfile, SignOut, Settings, FeedBack, Delete }

class ProfileAction {
  final String title;
  final Icon icon;
  final TypeProfileAction type;

  const ProfileAction(this.title, this.icon, this.type);
}
