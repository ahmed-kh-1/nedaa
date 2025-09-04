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

  /// Mark post as adopted by the current user's organization and log adoption.
  Future<void> adoptPost(String postId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('يجب تسجيل الدخول لإتمام العملية');
      }

      // Validate account type from user metadata if available
      final accountType = user.userMetadata?['account_type'];
      if (accountType != 'association') {
        throw Exception('هذا الإجراء متاح فقط لحسابات الجمعيات');
      }

      // Find the organization that belongs to this user (owner_id = auth.users.id)
      final orgRow = await _supabase
          .from('organizations')
          .select('id')
          .eq('owner_id', user.id)
          .maybeSingle();

      if (orgRow == null || orgRow['id'] == null) {
        throw Exception('لم يتم العثور على جمعية مرتبطة بهذا الحساب');
      }
      final String orgId = orgRow['id'] as String;

      // 1) Update post as adopted
      await _supabase
          .from(_table)
          .update({'is_adopted': true})
          .eq('id', postId);

      // 2) Insert adoption record
      await _supabase.from('adoptions').insert({
        'post_id': postId,
        'org_id': orgId,
      });
    } catch (e) {
      print('Error adopting post: $e');
      throw Exception('فشل في تبني البلاغ: $e');
    }
  }
}
