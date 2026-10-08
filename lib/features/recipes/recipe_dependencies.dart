import 'package:food_app/data/database/app_database.dart';

import 'data/repositories/recipe_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/services/recipe_service.dart';
import 'domain/services/user_service.dart';

class RecipeDependencies {
  static final AppDatabase database = AppDatabase();

  static final RecipeService recipeService = RecipeService(
    RecipeRepositoryImpl(database),
  );

  static final UserService userService = UserService(
    UserRepositoryImpl(database),
  );
}
