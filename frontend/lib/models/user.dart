class User {
  final String email;
  final String? password;
  final String nickName;

  User({
    required this.email,
    this.password,
    required this.nickName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String?,
      nickName: json['nickName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (password != null) 'password': password,
      'nickName': nickName,
    };
  }
}
