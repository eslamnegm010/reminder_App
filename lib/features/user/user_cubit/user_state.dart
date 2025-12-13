import 'package:reminder_app/features/user/model/user.dart';
import 'package:flutter/foundation.dart';

enum UserStatus { initial, loaded }

@immutable
class UserState {
  final UserStatus status;
  final UserModel? user;

  const UserState({this.status = UserStatus.initial, this.user});

  UserState copyWith({UserStatus? status, UserModel? user}) {
    return UserState(status: status ?? this.status, user: user ?? this.user);
  }
}
