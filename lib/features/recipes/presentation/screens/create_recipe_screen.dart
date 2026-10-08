import 'package:flutter/material.dart';

import '../../domain/model/recipe.dart';
import '../../recipe_dependencies.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const CreateRecipeScreen({super.key, this.recipe});

  bool get isEditing => recipe != null;

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  late final TextEditingController creatorNameController;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController ingredientsController;
  late final TextEditingController instructionsController;

  @override
  void initState() {
    super.initState();

    creatorNameController = TextEditingController(
      text: widget.recipe?.creatorName ?? '',
    );

    titleController = TextEditingController(text: widget.recipe?.title ?? '');

    descriptionController = TextEditingController(
      text: widget.recipe?.description ?? '',
    );

    ingredientsController = TextEditingController(
      text: widget.recipe?.ingredients ?? '',
    );

    instructionsController = TextEditingController(
      text: widget.recipe?.instructions ?? '',
    );
  }

  Future<void> saveRecipe() async {
    final creatorName = creatorNameController.text.trim();
    final title = titleController.text.trim();

    if (creatorName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the creator name.')),
      );
      return;
    }

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipe title.')),
      );
      return;
    }

    if (widget.isEditing) {
      final updatedRecipe = Recipe(
        id: widget.recipe!.id,
        title: title,
        description: descriptionController.text.trim(),
        ingredients: ingredientsController.text.trim(),
        instructions: instructionsController.text.trim(),
        creatorName: creatorName,
      );

      await RecipeDependencies.recipeService.updateRecipe(updatedRecipe);
    } else {
      final recipe = Recipe(
        title: title,
        description: descriptionController.text.trim(),
        ingredients: ingredientsController.text.trim(),
        instructions: instructionsController.text.trim(),
        creatorName: creatorName,
      );

      await RecipeDependencies.recipeService.addRecipe(recipe);
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> deleteRecipe() async {
    if (widget.recipe?.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recipe?'),
          content: const Text('This recipe will be permanently deleted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await RecipeDependencies.recipeService.deleteRecipe(widget.recipe!.id!);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    creatorNameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Recipe' : 'Create Recipe'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: deleteRecipe,
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: creatorNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: ingredientsController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instructionsController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveRecipe,
                child: Text(widget.isEditing ? 'UPDATE RECIPE' : 'SAVE RECIPE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
