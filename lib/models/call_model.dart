class CallModel {
  final String id;
  final String postId;
  final String organizationId;
  final String callerId;
  final String callerName;
  final DateTime createdAt;

  CallModel({
    required this.id,
    required this.postId,
    required this.organizationId,
    required this.callerId,
    required this.callerName,
    required this.createdAt,
  });

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      id: map['id'] ?? '',
      postId: map['post_id'] ?? '',
      organizationId: map['organization_id'] ?? '',
      callerId: map['caller_id'] ?? '',
      callerName: map['caller_name'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'organization_id': organizationId,
      'caller_id': callerId,
      'caller_name': callerName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CallModel copyWith({
    String? id,
    String? postId,
    String? organizationId,
    String? callerId,
    String? callerName,
    DateTime? createdAt,
  }) {
    return CallModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      organizationId: organizationId ?? this.organizationId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
