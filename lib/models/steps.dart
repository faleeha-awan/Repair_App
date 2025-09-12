class StepModel{
  final String id;
  final String guideId;
  final String title;
  final String? imageUrl;

  StepModel({
    required this.id,
    required this.guideId,
    required this.title,
    this.imageUrl,
  });

}