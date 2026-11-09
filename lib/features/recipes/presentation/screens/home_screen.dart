import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/recipe.dart';
import '../providers/recipe_providers.dart';
import 'create_recipe_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _openRecipe(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateRecipeScreen(recipe: recipe)),
    );

    ref.invalidate(recipesProvider);
  }

  Future<void> _createRecipe(BuildContext context, WidgetRef ref) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
    );

    ref.invalidate(recipesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF8),
        elevation: 0,
        title: const Text(
          'FOOD APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Kitchen 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ready to cook something?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Text(
              'Your Recipes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recipesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Something went wrong:\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (recipes) {
                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No recipes yet.\nCreate your first recipe!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return Card(
                        child: ListTile(
                          title: Text(recipe.title),
                          subtitle: Text('Created by ${recipe.creatorName}'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => _openRecipe(context, ref, recipe),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _createRecipe(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
