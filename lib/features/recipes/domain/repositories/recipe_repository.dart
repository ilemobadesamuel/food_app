import '../model/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();

  Future<void> addRecipe(Recipe recipe);

  Future<void> updateRecipe(Recipe recipe);

  Future<void> deleteRecipe(int id);
}
