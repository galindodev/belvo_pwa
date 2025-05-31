

class User {
  final String email;
  final String username;
  final String link;

  User({required this.email, required this.username, required this.link});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      link: json['link'],
    );
  }
}