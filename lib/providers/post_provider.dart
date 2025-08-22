import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';
import 'package:call/services/post_service.dart';
import 'dart:io';

class PostProvider with ChangeNotifier {
  final PostService _service = PostService();

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<PostModel> _userPosts = [];
  List<PostModel> get userPosts => _userPosts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PostModel? _currentPost;
  PostModel? get currentPost => _currentPost;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    _setLoading(true);
    _setError(null);
    try {
      _posts = await _service.getAllPosts();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUserPosts() async {
    _setLoading(true);
    _setError(null);
    try {
      _userPosts = await _service.getUserPosts();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPost(PostModel post, {File? image}) async {
    _setLoading(true);
    _setError(null);
    try {
      if (image != null) {
        final String? imageUrl = await uploadImage(image, post.postId);

        await _service.addPost(post.copyWith(imageUrl: imageUrl));
        await fetchPosts();
      } else {
        await _service.addPost(post);
        await fetchPosts();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePost(String id, PostModel post, {File? image}) async {
    _setLoading(true);
    _setError(null);
    try {
      if (image != null) {
        final String? imageUrl = await uploadImage(image, post.postId);

        await _service.updatePost(id, post.copyWith(imageUrl: imageUrl));
      } else {
        await _service.updatePost(id, post);
      }
      // Refresh lists so all screens stay in sync
      await fetchPosts();
      await fetchUserPosts();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.deletePost(id);
      // Refresh lists so all screens stay in sync
      await fetchPosts();
      await fetchUserPosts();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getPostById(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentPost = await _service.getPostById(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearCurrentPost() {
    _currentPost = null;
    notifyListeners();
  }

  Future<String?> uploadImage(File image, String postId) async {
    try {
      return await _service.uploadPostImage(image, postId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }
}
