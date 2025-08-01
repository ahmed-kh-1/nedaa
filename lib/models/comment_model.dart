class CommentModel {
  final String id;
  final String postId;
  final String commenterId;
  final String commenterName;
  final String commentText;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.commenterId,
    required this.commenterName,
    required this.commentText,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['post_id'] ?? '',
      commenterId: map['commenter_id'] ?? '',
      commenterName: map['commenter_name'] ?? '',
      commentText: map['comment_text'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'commenter_id': commenterId,
      'commenter_name': commenterName,
      'comment_text': commentText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? commenterId,
    String? commenterName,
    String? commentText,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      commenterId: commenterId ?? this.commenterId,
      commenterName: commenterName ?? this.commenterName,
      commentText: commentText ?? this.commentText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
