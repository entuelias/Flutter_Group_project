import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetUserDetailsUseCase {
  final AuthRepository _authRepository;

  GetUserDetailsUseCase(this._authRepository);

  Future<User?> call(String userId) async {
    return await _authRepository.getUserDetails(userId);
  }
} 