import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository _userRepository;
  final FlutterSecureStorage _secureStorage;

  GetUserProfileUseCase(this._userRepository, this._secureStorage);

  Future<User> execute() async {
    // Get JWT token from secure storage
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Not authenticated');
    }

    // Call repository to get user profile
    return await _userRepository.getUserProfile(token);
  }
} 