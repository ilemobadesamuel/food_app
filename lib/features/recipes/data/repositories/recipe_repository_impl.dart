import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

import '../../domain/model/recipe.dart' as recipe_model;
import '../../domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final AppDatabase database;

  RecipeRepositoryImpl(this.database);

  @override
  Future<List<recipe_model.Recipe>> getRecipes() async {
    final rows = await database.select(database.recipes).get();

    return rows.map((row) {
      return recipe_model.Recipe(
        id: row.id,
        title: row.title,
        description: row.description ?? '',
        ingredients: row.ingredients,
        instructions: row.instructions,
        creatorName: row.creatorName,
      );
    }).toList();
  }

  @override
  Future<void> addRecipe(recipe_model.Recipe recipe) async {
    await database
        .into(database.recipes)
        .insert(
          RecipesCompanion.insert(
            title: recipe.title,
            description: Value(recipe.description),
            ingredients: recipe.ingredients,
            instructions: recipe.instructions,
            creatorName: Value(recipe.creatorName),
          ),
        );
  }

  @override
  Future<void> updateRecipe(recipe_model.Recipe recipe) async {
    await database
        .update(database.recipes)
        .replace(
          RecipesCompanion(
            id: Value(recipe.id!),
            title: Value(recipe.title),
            description: Value(recipe.description),
            ingredients: Value(recipe.ingredients),
            instructions: Value(recipe.instructions),
            creatorName: Value(recipe.creatorName),
          ),
        );
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await (database.delete(
      database.recipes,
    )..where((table) => table.id.equals(id))).go();
  }
}
