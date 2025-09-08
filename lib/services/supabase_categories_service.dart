import 'package:my_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  static final _client = Supabase.instance.client;

  //Fetch all categories from supabase
  static Future<List<Category>> fetchCategories () async {
    try{
      final response = await _client
      .from ('categories')
      .select ('id, name, icon_name, parent_id');

      //Convert rows into Category objects
      final allCategories = (response as List)
      .map ((row)=> Category(
        id: row ['id'].toString(),
        name : row ['name'] ?? 'Untitled',
        iconName: row ['icon_name'],
        subcategories: [], //fill later
        guideIds: [] //fill later
        ))
      .toList();

      //Build Nested Structure (parent/child)
      final Map<String, Category> byId = {
        for (var cat in allCategories) cat.id: cat
      };

      final List<Category> rootCategories = [];

      for (var row in response){
        final cat = byId[row['id'].toString()]!;
        final parentId = row['parent_id'];
        if (parentId == null){
          rootCategories.add(cat);
        }else{
          final parent = byId[parentId.toString()];
          if (parent != null){
          parent.subcategories.add(cat);
          }
        }
      }
      return rootCategories;
      
    }catch (e, st){
      Logger.error("Error fetching categories", error: e, stackTrace: st);
      return [];
    }

  }
}
