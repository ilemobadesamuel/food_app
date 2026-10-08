abstract class UserRepository {
  Future<bool> isNameTaken(String name);

  Future<void> addUser(String name);

  Future<List<String>> getUsers();
}
