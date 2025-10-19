import 'package:bloc/bloc.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_state.dart';
import 'package:eslam_s_application/features/user/model/user.dart';
import 'package:hive/hive.dart';

class UserCubit extends Cubit<UserState> {
  final Box<UserModel> _box;
  static const _key = 'current_user';

  UserCubit(this._box) : super(const UserState()) {
    _load();
  }

  void _load() {
    final user = _box.get(_key);
    if (user != null) {
      emit(state.copyWith(status: UserStatus.loaded, user: user));
    } else {
      emit(state.copyWith(status: UserStatus.initial, user: null));
    }
  }

  void saveUser({required String name, required String email}) {
    final user = UserModel(name: name.trim(), email: email.trim());
    _box.put(_key, user);

    emit(state.copyWith(status: UserStatus.loaded, user: user));
  }

  void clearUser() {
    _box.delete(_key);
    emit(const UserState());
  }
}
