class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String? _id;
  String? _role;
  String? _token;
  String? _email;
  String? _name;

  void setId(String id) {
    _id = id;
  }

  void setRole(String role) {
    _role = role;
  }

  void setToken(String token) {
    _token = token;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setName(String name) {
    _name = name;
  }

  String? getId() {
    return _id;
  }

  String? getToken() {
    return _token;
  }

  String? getEmail() {
    return _email;
  }

  String? getRole() {
    return _role;
  }

  String? getName() {
    return _name;
  }

  bool get isAdmin => _role == 'admin';
  bool get isClient => _role == 'client';
}
