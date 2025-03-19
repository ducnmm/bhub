class GoogleAuthResponse {
  final String id;
  final String name;
  final String email;
  final String photo_url;
  final String token;

  GoogleAuthResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.photo_url,
    required this.token,
  });

  factory GoogleAuthResponse.fromJson(Map<String, dynamic> json) {
    return GoogleAuthResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photo_url: json['photo_url'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photo_url,
      'token': token,
    };
  }
}
