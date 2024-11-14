class User {
  final int id;
  final String name;
  final String email;
  final String token;

  User({required this.id, required this.name, required this.email, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['data']['user_id'],
      name: json['data']['user_name'],
      email: json['data']['user_email'],
      token: json['data']['token'],
    );
  }
}
