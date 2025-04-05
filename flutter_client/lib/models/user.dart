class User {
  final int id;
  final String username;
  final String email;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.isOnline = false,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isOnline: json['is_online'] ?? false,
      lastSeen: DateTime.parse(json['last_seen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_online': isOnline,
      'last_seen': lastSeen.toIso8601String(),
    };
  }
} 