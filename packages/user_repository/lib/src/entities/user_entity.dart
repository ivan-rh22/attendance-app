class MyUserEntity {
  String userId;
  String email;
  String name;
  final bool isTeacher;
  List<String> courses;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.isTeacher,
    List<String>? courses,
  }) : courses = courses ?? [];

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'isTeacher': isTeacher,
      'courses': courses,
    };
  }

  static MyUserEntity fromJson(Map<String, dynamic> json) {
    return MyUserEntity(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      isTeacher: json['isTeacher'],
      courses: json['courses'] != null ? List<String>.from(json['courses']) : [],
    );
  }
}