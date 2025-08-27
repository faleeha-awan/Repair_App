enum SearchResultType {
  guide,
  external,
}

class SearchResult {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final SearchResultType type;
  final String? sourceUrl; // For external results
  final String? sourceName; // e.g., "YouTube", "Google"
  final double? relevanceScore;

  SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.type,
    this.sourceUrl,
    this.sourceName,
    this.relevanceScore,
  });

  // Create a copy with updated fields
  SearchResult copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    SearchResultType? type,
    String? sourceUrl,
    String? sourceName,
    double? relevanceScore,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceName: sourceName ?? this.sourceName,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }
}