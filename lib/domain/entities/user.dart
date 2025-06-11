class User {
  final String? id;
  final String username;
  final String email;
  final DateTime dateOfBirth;
  final String bloodType;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.dateOfBirth,
    required this.bloodType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bloodType': bloodType,
    };
    if (id != null) {
      data['_id'] = id;
    }
    return data;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      bloodType: json['bloodType'],
    );
  }
} 