import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;
  bool isTeacher;
  List<String> courses;

  MyUser({
      required this.userId,
      required this.email,
      required this.name,
      required this.isTeacher,
      List<String>? courses,
  }) : courses = courses ?? [];

  static final empty = MyUser(userId: '', email: '', name: '', isTeacher: false, );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email, 
      name: name, 
      isTeacher: isTeacher,
      courses: courses
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      isTeacher: entity.isTeacher,
      courses: entity.courses
    );
  }

  @override
  String toString(){
    return 'MyUser: $userId, $email, $name, $isTeacher, $courses';
  }
}
