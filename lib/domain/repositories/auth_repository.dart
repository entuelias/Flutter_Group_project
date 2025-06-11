import '../entities/user.dart';
import '../../core/params/login_params.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp(User user, String password);
  Future<User> login(LoginParams params);
  Future<void> logout();
  Future<User?> getUserDetails(String userId);
} 