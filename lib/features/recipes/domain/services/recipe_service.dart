import '../model/recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeService {
  final RecipeRepository repository;

  RecipeService(this.repository);

  Future<List<Recipe>> getRecipes() {
    return repository.getRecipes();
  }

  Future<void> addRecipe(Recipe recipe) {
    return repository.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe) {
    return repository.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(int id) {
    return repository.deleteRecipe(id);
  }
}
