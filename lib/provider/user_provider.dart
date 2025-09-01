import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserData {
  final String name;
  final String surname;
  final bool read;

  UserData({
    this.name = '',
    this.surname = '',
    this.read = false,
  });

  UserData copyWith({
    String? name,
    String? surname,
    bool? read,
  }) {
    return UserData(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      read: read ?? this.read,
    );
  }
}

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(UserData());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setSurname(String surname) {
    state = state.copyWith(surname: surname);
  }

  void setRead(bool read) {
    state = state.copyWith(read: read);
  }
  bool fifi() {
    return state.read;
  }

  void clear() {
    state = UserData();
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserData>((ref) {
  return UserDataNotifier();
});

