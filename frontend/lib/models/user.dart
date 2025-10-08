class User {
  final int? userId;
  final String email;
  final String? password;
  final String nickName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.userId,
    required this.email,
    this.password,
    required this.nickName,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int?,
      email: json['email'] as String,
      password: json['password'] as String?,
      nickName: json['nickName'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'email': email,
      if (password != null) 'password': password,
      'nickName': nickName,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
