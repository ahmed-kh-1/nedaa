class PostModel {
  final String userName;
  final String timeAgo;
  final String title;
  final String description;
  final int likes;
  final int comments;
  List<String>? _savedComments;
  final bool isAdopted;
  final String? adoptedBy;

  PostModel({
    required this.userName,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    List<String>? savedComments,
    this.isAdopted = false,
    this.adoptedBy,
  }) : _savedComments = savedComments;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userName: json['userName'] ?? 'مستخدم مجهول',
      timeAgo: json['timeAgo'] ?? 'منذ فترة',
      title: json['title'] ?? 'بدون عنوان',
      description: json['description'] ?? 'لا يوجد وصف',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      savedComments: json['savedComments'] != null
          ? List<String>.from(json['savedComments'])
          : null,
      isAdopted: json['isAdopted'] ?? false,
      adoptedBy: json['adoptedBy'],
    );
  }

  List<String>? get savedComments => _savedComments;

  bool get isLiked => false;

  set savedComments(List<String>? comments) {
    _savedComments = comments;
  }

  PostModel copyWith({
    String? userName,
    String? timeAgo,
    String? title,
    String? description,
    int? likes,
    int? comments,
    List<String>? savedComments,
    bool? isAdopted,
    String? adoptedBy,
    required bool isLiked,
  }) {
    return PostModel(
      userName: userName ?? this.userName,
      timeAgo: timeAgo ?? this.timeAgo,
      title: title ?? this.title,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      savedComments: savedComments ?? _savedComments,
      isAdopted: isAdopted ?? this.isAdopted,
      adoptedBy: adoptedBy ?? this.adoptedBy,
    );
  }
}
