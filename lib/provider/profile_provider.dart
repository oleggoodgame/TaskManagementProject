// class ProfileProvider extends StateNotifier<Profile> {
//   ProfileProvider()
//     : super(
//         Profile(
//           firstName: "",
//           lastName: "",
//           email: '',
//         ),
//       );

//   void updateProfile({
//     String? firstName,
//     String? lastName,
//   }) {
//     state = state.copyWith(
//       firstName: firstName,
//       lastName: lastName,
//     );
//   }

// }

// final profileProvider = StateNotifierProvider<ProfileProvider, Profile>(
//   (ref) => ProfileProvider(),
// );

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/models/profile.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  final _db = DatabaseService();

  @override
  Future<Profile?> build() async {
    return await _db.getMyProfile();
  }

  Future<String?> getCompany() async {
    final profile = state.value;
    if (profile == null || profile.company == null) return null;
    print(profile.company);
    return await _db.getCompanyName(profile.company!);
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _db.getMyProfile());
  }

  Future<void> updateImage(String imageUrl) async {
    await _db.updateProfilePhoto(imageUrl);
  }

  Future<void> createOrUpdateProfile(User user) async {
    final userId = user.uid;

    final existingProfile = await _db.getProfile(userId);
print(existingProfile);
    if (existingProfile == null) {
      await _db.addProfile(
        userId,
        "", 
        "",
        true, 
        false,
        false, 
      );
    }

    // Після цього одразу оновлюємо state, щоб UI бачив свіжий профіль
    state = await AsyncValue.guard(() => _db.getMyProfile());
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
