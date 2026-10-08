class Recipe {
  final int? id;
  final String title;
  final String description;
  final String ingredients;
  final String instructions;
  final String creatorName;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.creatorName,
  });
}
