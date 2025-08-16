import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/call_model.dart';

class CallService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'calls';

  Future<List<CallModel>> getCallsByPostId(String postId) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      return response.map((map) => CallModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching calls: $e');
      throw Exception('فشل في جلب النداءات: $e');
    }
  }

  Future<List<CallModel>> getCallsByOrgId(String orgId) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('organization_id', orgId)
          .order('created_at', ascending: false);

      return response.map((map) => CallModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching calls: $e');
      throw Exception('فشل في جلب النداءات: $e');
    }
  }

  Future<void> addCall(CallModel call) async {
    try {
      await _supabase.from(_table).insert(call.toMap());
    } catch (e) {
      print('Error adding call: $e');
      throw Exception('فشل في إضافة النداء: $e');
    }
  }

  Future<void> deleteCall(String id) async {
    try {
      await _supabase.from(_table).delete().eq('id', id);
    } catch (e) {
      print('Error deleting call: $e');
      throw Exception('فشل في حذف النداء: $e');
    }
  }
}
