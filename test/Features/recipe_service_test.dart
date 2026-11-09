import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:food_app/features/recipes/domain/model/recipe.dart';
import 'package:food_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:food_app/features/recipes/domain/services/recipe_service.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late MockRecipeRepository mockRepository;
  late RecipeService recipeService;

  setUp(() {
    mockRepository = MockRecipeRepository();
    recipeService = RecipeService(mockRepository);
  });

  group('RecipeService', () {
    test('getRecipes returns recipes from repository', () async {
      final recipes = <Recipe>[
        Recipe(
          title: 'Jollof Rice',
          description: 'Nigerian Jollof',
          ingredients: 'Rice, tomatoes',
          instructions: 'Cook everything',
          creatorName: 'Samuel',
        ),
      ];

      when(() => mockRepository.getRecipes()).thenAnswer((_) async => recipes);

      final result = await recipeService.getRecipes();

      expect(result, recipes);
      verify(() => mockRepository.getRecipes()).called(1);
    });

    test('addRecipe calls repository', () async {
      final recipe = Recipe(
        title: 'Jollof Rice',
        description: 'Nigerian Jollof',
        ingredients: 'Rice, tomatoes',
        instructions: 'Cook everything',
        creatorName: 'Samuel',
      );

      when(() => mockRepository.addRecipe(recipe)).thenAnswer((_) async {});

      await recipeService.addRecipe(recipe);

      verify(() => mockRepository.addRecipe(recipe)).called(1);
    });

    test('updateRecipe calls repository', () async {
      final recipe = Recipe(
        id: 1,
        title: 'Jollof Rice',
        description: 'Updated recipe',
        ingredients: 'Rice, tomatoes',
        instructions: 'Cook everything',
        creatorName: 'Samuel',
      );

      when(() => mockRepository.updateRecipe(recipe)).thenAnswer((_) async {});

      await recipeService.updateRecipe(recipe);

      verify(() => mockRepository.updateRecipe(recipe)).called(1);
    });

    test('deleteRecipe calls repository', () async {
      when(() => mockRepository.deleteRecipe(1)).thenAnswer((_) async {});

      await recipeService.deleteRecipe(1);

      verify(() => mockRepository.deleteRecipe(1)).called(1);
    });
  });
}
