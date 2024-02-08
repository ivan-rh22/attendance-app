import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;
  final bool isTeacher;

  MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.isTeacher
  });

  static final empty = MyUser(userId: '', email: '', name: '', isTeacher: false);

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email, 
      name: name, 
      isTeacher: isTeacher);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      isTeacher: entity.isTeacher
    );
  }

  @override
  String toString(){
    return 'MyUser: $userId, $email, $name, $isTeacher';
  }
}
