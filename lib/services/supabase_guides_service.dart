import 'package:my_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/guide.dart';

class GuideService{
  static final _client = Supabase.instance.client;

  //fetch all guides that belong to a given category/subcategory
  static Future <List<Guide>> fetchGuidesForCategory (String categoryId) async {

    try {
      //1. Query Supabase
      final response = await _client
      .from ('Repair_Guides')
      .select ('id, title, steps_count, summary, cover_image_url, time_required, is_public, subcategory_id')
      .eq ('subcategory_id', categoryId)
      .eq ('is_public', true)
      .order ('title', ascending: true);

     //2. Cast rows to usable List
      final rows = List <Map<String, dynamic>>. from (response);

      //3. Map each row into a guide obj
      final guides = rows.map((row){
        return Guide(
          id: row['id'].toString(),
          title: row['title']?? 'Untitled Guide', 
          lastOpened: DateTime.now(), 
          totalSteps: row['steps_count']?? 0, 
          completedSteps: 0, 
          isBookmarked: false
        );
      }).toList();

      return guides;
    } catch (e, st){
      Logger.error ('Error fetching guides for $categoryId', error: e, stackTrace: st);
      return [];
    }

  }

}
