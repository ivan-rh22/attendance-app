class MyUserEntity {
  String userId;
  String email;
  String name;
  final bool isTeacher;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.isTeacher
  });

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'isTeacher': isTeacher
    };
  }

  static MyUserEntity fromJson(Map<String, dynamic> json) {
    return MyUserEntity(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      isTeacher: json['isTeacher'],
    );
  }
}