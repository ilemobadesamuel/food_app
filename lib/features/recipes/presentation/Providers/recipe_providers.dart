import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/database/app_database.dart' hide Recipe;

import '../../domain/model/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/services/recipe_service.dart';
import '../../data/repositories/recipe_repository_impl.dart';

// Creates and manages the database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});

// Provides the recipe repository.
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return RecipeRepositoryImpl(database);
});

// Provides the recipe service.
final recipeServiceProvider = Provider<RecipeService>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);

  return RecipeService(repository);
});

// Loads recipes asynchronously.
final recipesProvider = FutureProvider<List<Recipe>>((ref) {
  final recipeService = ref.watch(recipeServiceProvider);

  return recipeService.getRecipes();
});
