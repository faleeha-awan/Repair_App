class Guide {
  // properties
  final String id;
  final String title;
  final String? thumbnailUrl;
  final DateTime lastOpened;
  final int totalSteps;
  final int completedSteps;
  final bool isBookmarked;

  // constructor
  Guide({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    required this.lastOpened,
    required this.totalSteps,
    required this.completedSteps,
    required this.isBookmarked,
  });

  // Convert Guide to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'lastOpened': lastOpened.toIso8601String(),
      'totalSteps': totalSteps,
      'completedSteps': completedSteps,
      'isBookmarked': isBookmarked,
    };
  }

  // Create Guide from JSON
  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      lastOpened: DateTime.parse(json['lastOpened']),
      totalSteps: json['totalSteps'],
      completedSteps: json['completedSteps'],
      isBookmarked: json['isBookmarked'],
    );
  }

  // Create a copy guide with updated fields
  Guide copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    DateTime? lastOpened,
    int? totalSteps,
    int? completedSteps,
    bool? isBookmarked,
  }) {
    return Guide(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      lastOpened: lastOpened ?? this.lastOpened,
      totalSteps: totalSteps ?? this.totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // Calculate progress percentage 
  double get progressPercentage {
    if (totalSteps == 0) return 0.0;
    return completedSteps / totalSteps;
  }
}