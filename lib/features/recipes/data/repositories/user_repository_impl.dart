import 'package:food_app/data/database/app_database.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase database;

  UserRepositoryImpl(this.database);

  @override
  Future<bool> isNameTaken(String name) async {
    final users = await database.select(database.users).get();

    return users.any(
      (user) => user.name.toLowerCase() == name.trim().toLowerCase(),
    );
  }

  @override
  Future<void> addUser(String name) async {
    await database
        .into(database.users)
        .insert(UsersCompanion.insert(name: name.trim()));
  }

  @override
  Future<List<String>> getUsers() async {
    final users = await database.select(database.users).get();

    return users.map((user) => user.name).toList();
  }
}
