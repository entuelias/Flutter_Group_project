import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> getUserProfile(String token) async {
    return await _remoteDataSource.getUserProfile(token);
  }

  @override
  Future<User> updateUserProfile(String token, User user) async {
    return await _remoteDataSource.updateUserProfile(token, user);
  }
} 