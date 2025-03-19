class User {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.phoneNumber = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create a copy of User with updated fields
  User copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: this.createdAt,
    );
  }
}