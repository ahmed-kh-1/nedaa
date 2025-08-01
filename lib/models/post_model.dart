class PostModel {
  final String postId;
  final String posterName;
  final String posterId;
  final String postText;
  final String postType;
  final bool isAdopted;
  final String? imageUrl;
  final String locationUrl;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.posterName,
    required this.posterId,
    required this.postText,
    required this.postType,
    required this.isAdopted,
    this.imageUrl,
    required this.locationUrl,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['id'] ?? '',
      posterName: map['poster_name'] ?? '',
      posterId: map['poster_id'] ?? '',
      postText: map['post_text'] ?? '',
      postType: map['post_type'] ?? '',
      isAdopted: map['is_adopted'] ?? false,
      imageUrl: map['image_url'],
      locationUrl: map['location_url'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'poster_name': posterName,
      'poster_id': posterId,
      'post_text': postText,
      'post_type': postType,
      'is_adopted': isAdopted,
      'image_url': imageUrl,
      'location_url': locationUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PostModel copyWith({
    String? postId,
    String? posterName,
    String? posterId,
    String? postText,
    String? postType,
    bool? isAdopted,
    String? imageUrl,
    String? locationUrl,
    DateTime? createdAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      posterName: posterName ?? this.posterName,
      posterId: posterId ?? this.posterId,
      postText: postText ?? this.postText,
      postType: postType ?? this.postType,
      isAdopted: isAdopted ?? this.isAdopted,
      imageUrl: imageUrl ?? this.imageUrl,
      locationUrl: locationUrl ?? this.locationUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
