import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  SignUpUseCase(this._authRepository, this._secureStorage);

  Future<User> execute({
    required String username,
    required String email,
    required String password,
    required DateTime dateOfBirth,
    required String bloodType,
  }) async {
    // Validate input
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }
    if (!_isValidPassword(password)) {
      throw Exception('Password must be at least 8 characters long and contain uppercase, lowercase, number and special character');
    }
    if (!_isValidUsername(username)) {
      throw Exception('Username must be at least 3 characters long');
    }

    // Create user entity
    final user = User(
      username: username,
      email: email,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType,
    );

    // Call repository to sign up
    final response = await _authRepository.signUp(user, password);
    
    // Store JWT token securely
    await _secureStorage.write(key: 'jwt_token', value: response['token']);
    
    // Return the created user
    return User.fromJson(response);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  bool _isValidUsername(String username) {
    return username.length >= 3;
  }
} 