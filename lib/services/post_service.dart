import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/post_model.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'posts';

  Future<String?> uploadPostImage(File image, String postId) async {
    try {
      final fileName = '${postId}_${path.basename(image.path)}';
      await _supabase.storage.from('images').upload(fileName, image);

      // Create a signed URL for the uploaded image
      final urlResponse = await _supabase.storage
          .from('images')
          .createSignedUrl(fileName, 31536000); // 1 year expiry
      return urlResponse;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  Future<void> addPost(PostModel post) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final postWithUser = post.copyWith(posterId: userId);
      await _supabase.from(_table).insert(postWithUser.toMap());
    } catch (e) {
      print('Error adding post: $e');
      throw Exception('فشل في إضافة البلاغ: $e');
    }
  }

  Future<void> updatePost(String id, PostModel post) async {
    try {
      await _supabase.from(_table).update(post.toMap()).eq('id', id);
    } catch (e) {
      print('Error updating post: $e');
      throw Exception('فشل في تحديث البلاغ: $e');
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _supabase.from(_table).delete().eq('id', id);
    } catch (e) {
      print('Error deleting post: $e');
      throw Exception('فشل في حذف البلاغ: $e');
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      final List data = await _supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      return data.map((e) => PostModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('فشل في جلب البلاغات: $e');
    }
  }

  Future<List<PostModel>> getUserPosts() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final List data = await _supabase
          .from(_table)
          .select()
          .eq('poster_id', userId)
          .order('created_at', ascending: false);
      return data.map((e) => PostModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching user posts: $e');
      throw Exception('فشل في جلب بلاغاتك: $e');
    }
  }

  Future<PostModel?> getPostById(String id) async {
    try {
      final data = await _supabase.from(_table).select().eq('id', id).single();
      return PostModel.fromMap(data);
    } catch (e) {
      print('Error fetching post: $e');
      throw Exception('فشل في جلب البلاغ: $e');
    }
  }
}
