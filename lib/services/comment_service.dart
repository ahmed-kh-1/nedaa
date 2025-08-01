import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';

class CommentService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'comments';

  Future<List<CommentModel>> getCommentsByPostId(String postId) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return response.map((map) => CommentModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception('فشل في جلب التعليقات: $e');
    }
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      await _supabase.from(_table).insert(comment.toMap());
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('فشل في إضافة التعليق: $e');
    }
  }

  Future<void> updateComment(String id, CommentModel comment) async {
    try {
      await _supabase.from(_table).update(comment.toMap()).eq('id', id);
    } catch (e) {
      print('Error updating comment: $e');
      throw Exception('فشل في تحديث التعليق: $e');
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      await _supabase.from(_table).delete().eq('id', id);
    } catch (e) {
      print('Error deleting comment: $e');
      throw Exception('فشل في حذف التعليق: $e');
    }
  }
}
