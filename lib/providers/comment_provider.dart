import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  final CommentService _service = CommentService();

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchCommentsByPostId(String postId) async {
    _setLoading(true);
    _setError(null);
    try {
      _comments = await _service.getCommentsByPostId(postId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addComment(CommentModel comment) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.addComment(comment);
      _comments.add(comment);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateComment(String id, CommentModel updatedComment) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.updateComment(id, updatedComment);
      final index = _comments.indexWhere((comment) => comment.id == id);
      if (index != -1) {
        _comments[index] = updatedComment;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteComment(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.deleteComment(id);
      _comments.removeWhere((comment) => comment.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
