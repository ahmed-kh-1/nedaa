class OrganizationModel {
  final String id;
  final String name;
  final String shortDescription;
  final String generalDescription;
  final String phone;
  final String email;
  final String location;
  final String workingHours;
  final String ownerId;
  final String specialization;
  OrganizationModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.generalDescription,
    required this.phone,
    required this.email,
    required this.location,
    required this.workingHours,
    required this.ownerId,
    required this.specialization,
  });

  factory OrganizationModel.fromMap(Map<String, dynamic> map) {
    return OrganizationModel(
      id: map['id'],
      name: map['name'],
      shortDescription: map['short_description'],
      generalDescription: map['general_description'],
      phone: map['phone'],
      email: map['email'],
      location: map['location'],
      workingHours: map['working_hours'],
      ownerId: map['owner_id'],
      specialization: map['specialization'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'short_description': shortDescription,
      'general_description': generalDescription,
      'phone': phone,
      'email': email,
      'location': location,
      'working_hours': workingHours,
      'owner_id': ownerId,
      'specialization': specialization,
    };
  }

  OrganizationModel copyWith({
    String? id,
    String? name,
    String? shortDescription,
    String? generalDescription,
    String? phone,
    String? email,
    String? location,
    String? workingHours,
    String? ownerId,
    String? specialization,
  }) {
    return OrganizationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      generalDescription: generalDescription ?? this.generalDescription,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      workingHours: workingHours ?? this.workingHours,
      ownerId: ownerId ?? this.ownerId,
      specialization: specialization ?? this.specialization,
    );
  }
}
