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
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
