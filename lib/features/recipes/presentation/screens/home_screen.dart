import 'package:flutter/material.dart';

import '../../recipe_dependencies.dart';
import '../../domain/model/recipe.dart';
import 'create_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    _recipesFuture = RecipeDependencies.recipeService.getRecipes();
  }

  Future<void> _openRecipe(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateRecipeScreen(recipe: recipe)),
    );

    if (!mounted) return;

    setState(() {
      _loadRecipes();
    });
  }

  Future<void> _createRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
    );

    if (!mounted) return;

    setState(() {
      _loadRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final recipes = snapshot.data ?? [];

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
                          onTap: () => _openRecipe(recipe),
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
        onPressed: _createRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
