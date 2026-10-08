import '../repositories/user_repository.dart';

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<bool> isNameTaken(String name) {
    return repository.isNameTaken(name);
  }

  Future<void> addUser(String name) {
    return repository.addUser(name);
  }

  Future<List<String>> getUsers() {
    return repository.getUsers();
  }
}
