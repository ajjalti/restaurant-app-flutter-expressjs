class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  // Pour convertir en JSON (à envoyer à l'API)
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
