import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/profile.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateProfile(String name, String surname) async {
    final userId = user?.uid;
    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc('profile')
        .update({"name": name, "surname": surname});
  }

  // Future<void> updateProfileCompany(String companyId) async {
  //   final userId = user?.uid;

  //   // final companyRef = _db.collection("companies").doc(companyId);
  //   // final companySnap = await companyRef.get();

  //   // if (!companySnap.exists) {
  //   //   throw Exception("Company with id $companyId does not exist");
  //   // }

  //   await _db
  //       .collection("users")
  //       .doc(userId)
  //       .collection("profile")
  //       .doc("profile")
  //       .set({"idCompany": companyId}, SetOptions(merge: true));
  // }

  Future<void> updateCompanyProfile(
    bool empoyer,
    bool employee,
    String idCompany,
    String company,
  ) async {
    final userId = user?.uid;
    await _db
        .collection('company')
        .doc(idCompany)
        .collection('members')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .set({
          "userId": userId,
          "role": "worker",
          "joinedAt": DateTime.now().toIso8601String(),
        });
    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc('profile')
        .set({
          "company": company,
          "idCompany": idCompany,
          "employer": empoyer,
          "employee": employee,
        }, SetOptions(merge: true));
  }

  Future<void> addProfile(
    String userId,
    String name,
    String surname,
    bool read,
    bool employee,
    bool employer,
  ) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc("profile")
        .set({"name": name, "surname": surname, "read": read});
  }

  Future<void> deleteProfile() async {
    final userId = user?.uid;
    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc("profile")
        .delete();
  }

  Future<Profile?> getProfile(String userId) async {
    final doc = await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc("profile")
        .get();

    final data = doc.data() as Map<String, dynamic>;
    final String email = user!.email!;
    print("data[grhytrhjytjttttttttujjuyjkname");
    print(data["name"]);

    // final DateTime? birthDate = data['birthday'] != null
    //     ? (data['birthday'] as Timestamp).toDate()
    //     : null;

    return Profile(
      firstName: data["name"] ?? "",
      lastName: data['surname'] ?? "",
      email: email,
      ImageUrl: data["ImageUrl"],
      employee: data["employee"] ?? false,
      employer: data["employer"] ?? false,
      company: data["company"],
      idCompany: data["idCompany"],
    );
  }

  Future<Profile?> getMyProfile() async {
    final userId = user?.uid;

    final doc = await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc("profile")
        .get();

    final data = doc.data() as Map<String, dynamic>;
    final String email = user!.email!;
    print("data[grhytrhjytjttttttttujjuyjkname");
    print(data["name"]);

    // final DateTime? birthDate = data['birthday'] != null
    //     ? (data['birthday'] as Timestamp).toDate()
    //     : null;

    return Profile(
      firstName: data["name"] ?? "",
      lastName: data['surname'] ?? "",
      email: email,
      ImageUrl: data["ImageUrl"],
      employee: data["employee"] ?? false,
      employer: data["employer"] ?? false,
      company: data["company"],
      idCompany: data["idCompany"],
    );
  }

  Future<void> addTask(
    String date,
    String name,
    String description,
    String? companyId,
    int color,
  ) async {
    final userId = user?.uid;

    await _db
        .collection("company")
        .doc(companyId)
        .collection("tasks")
        .doc(date)
        .collection("task")
        .doc()
        .set({
          "name": name,
          "description": description,
          "color": color,
          "profile": userId,
        });
    ;
  }

  Stream<QuerySnapshot> getTasks(String? companyId, String date) {
    return _db
        .collection("company")
        .doc(companyId)
        .collection("tasks")
        .doc(date)
        .collection("task")
        .snapshots();
  }

  Future<void> updateTask(
    String date,
    String id,
    String? companyId,
    String name,
    String description,
    int color,
  ) async {
    return _db
        .collection("company")
        .doc(companyId)
        .collection("tasks")
        .doc(date)
        .collection("task")
        .doc(id)
        .update({"name": name, "description": description, "color": color});
  }

  Future<void> deleteTask(String dateTime, String id, String companyId) async {
    return _db
        .collection("company")
        .doc(companyId)
        .collection("tasks")
        .doc(dateTime)
        .collection("task")
        .doc(id)
        .delete();
  }

  Future<String> createCompany(
    String name,
    bool employer,
    bool employee,
  ) async {
    final docRef = _db.collection("company").doc();
    final userId = user?.uid;

    await updateCompanyProfile(employer, employee, docRef.id, name);
    await docRef.set({"Id": docRef.id, "Owner": userId, "Name": name});

    return docRef.id;
  }

  Future<bool> deleteMember(String userEmail, String idCompany) async {
    final membersRef = _db
        .collection('company')
        .doc(idCompany)
        .collection('members');

    final memberDoc = membersRef.doc(userEmail);

    final snapshot = await memberDoc.get();

    if (!snapshot.exists) {
      return false;
    }
    final userId = snapshot["userId"];
    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc('profile')
        .set({
          "company": null,
          "idCompany": null,
          "employee": false,
        }, SetOptions(merge: true));
    await memberDoc.delete();
    return true;
  }

  Future<String?> getCompanyName(String companyId) async {
    final doc = await _db.collection("company").doc(companyId).get();

    final data = doc.data();
    if (data == null) {
      return null;
    }
    return data["Name"];
  }

  Future<void> updateProfilePhoto(String image) async {
    final userId = user?.uid;

    await _db
        .collection("users")
        .doc(userId)
        .collection("profile")
        .doc('profile')
        .set({"ImageUrl": image}, SetOptions(merge: true));
  }
}
