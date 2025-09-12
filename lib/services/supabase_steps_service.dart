import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/steps.dart';

class StepService{
  static final _client = Supabase.instance.client;

  //Fetch all steps for a given guide
  static Future <List<StepModel>> fetchStepsForGuide (guideId) async {
    final response = await _client
    .from ('Repair_Steps')
    .select ('id, guide_id, title, image_url')
    .eq ('id', guideId)
    .order ('id', ascending: true);

    final rows = List<Map<String, dynamic>>.from (response);

    final steps = rows.map((row){
      return StepModel(
        id: row['id'].toString(),
        guideId: row['guide_id'].toString(),
        title: row['title']?? '',
        imageUrl: row['image_url']
      );
    }).toList();

    return steps;
  }
}