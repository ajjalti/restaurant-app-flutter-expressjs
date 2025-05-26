class AuthDto {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  AuthDto({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.token,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      token: json['token'],
    );
  }
}
