class Category {
  final String id;
  final String name;
  final String? description;
  final String? iconName;
  final List<Category> subcategories;
  final List<String> guideIds; // References to guides in this category

  Category({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.subcategories = const [],
    this.guideIds = const [],
  });

  // Check if this category has subcategories
  bool get hasSubcategories => subcategories.isNotEmpty;

  // Check if this category has guides
  //Not being passed correctly so not used for now
  bool get hasGuides => guideIds.isNotEmpty;

  // Create a copy with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    List<Category>? subcategories,
    List<String>? guideIds,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      subcategories: subcategories ?? this.subcategories,
      guideIds: guideIds ?? this.guideIds,
    );
  }
}