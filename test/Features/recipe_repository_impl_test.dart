import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:food_app/data/database/app_database.dart' hide Recipe;
import 'package:food_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:food_app/features/recipes/domain/model/recipe.dart';

void main() {
  late AppDatabase database;
  late RecipeRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = RecipeRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  final testRecipe = Recipe(
    title: 'Jollof Rice',
    description: 'Nigerian Jollof',
    ingredients: 'Rice, tomatoes, pepper',
    instructions: 'Cook everything',
    creatorName: 'Samuel',
  );

  group('RecipeRepositoryImpl', () {
    test('adds and retrieves a recipe', () async {
      await repository.addRecipe(testRecipe);

      final recipes = await repository.getRecipes();

      expect(recipes.length, 1);
      expect(recipes.first.title, 'Jollof Rice');
      expect(recipes.first.creatorName, 'Samuel');
    });

    test('updates a recipe', () async {
      await repository.addRecipe(testRecipe);

      final recipes = await repository.getRecipes();
      final savedRecipe = recipes.first;

      final updatedRecipe = Recipe(
        id: savedRecipe.id,
        title: 'Updated Jollof Rice',
        description: 'Updated description',
        ingredients: 'Rice, tomatoes',
        instructions: 'Updated instructions',
        creatorName: 'Samuel',
      );

      await repository.updateRecipe(updatedRecipe);

      final result = await repository.getRecipes();

      expect(result.first.title, 'Updated Jollof Rice');
      expect(result.first.description, 'Updated description');
    });

    test('deletes a recipe', () async {
      await repository.addRecipe(testRecipe);

      final recipes = await repository.getRecipes();
      await repository.deleteRecipe(recipes.first.id!);

      final result = await repository.getRecipes();

      expect(result, isEmpty);
    });
  });
}
