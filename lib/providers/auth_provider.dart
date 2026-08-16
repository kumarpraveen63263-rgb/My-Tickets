import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/local_storage_service.dart';

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isLoggedIn => user != null;

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final LocalStorageService _storage;

  AuthNotifier(this._repository, this._storage) : super(const AuthState()) {
    _restoreSession();
  }

  void _restoreSession() {
    if (_storage.isLoggedIn) {
      state = AuthState(
        user: UserModel(
          id: 'u_${_storage.userPhone}',
          name: _storage.userName ?? 'MyTickets User',
          phone: _storage.userPhone ?? '',
          bookingsCount: 4,
          savedCount: 6,
          rewardPoints: 240,
        ),
      );
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendOtp(phone);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.verifyOtp(phone, otp);
      await _storage.saveSession(phone: user.phone, name: user.name);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid OTP. Please try again.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await _storage.clearSession();
    state = const AuthState();
  }

  void updateProfile({String? name, String? email}) {
    if (state.user == null) return;
    state = state.copyWith(
      user: state.user!.copyWith(name: name, email: email),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(localStorageServiceProvider),
  );
});
