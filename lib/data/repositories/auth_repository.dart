import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthRepository {
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  /// Local demo auth: use the fixed demo OTP shown in the verification screen.
  Future<UserModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (otp != AppConstants.demoOtp) {
      throw Exception('Invalid OTP');
    }
    return UserModel(
      id: 'u_$phone',
      name: 'Praveen Kumar',
      phone: phone,
      email: 'praveen@example.com',
      avatarUrl: null,
      bookingsCount: 4,
      savedCount: 6,
      rewardPoints: 240,
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
