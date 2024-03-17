import 'package:user_repository/user_repository.dart';

MyUser student = MyUser(
  userId: '1234', 
  email: 'student@email.com',
  name: 'student name',
  isTeacher: false
);

MyUser teacher = MyUser(
  userId: '1234', 
  email: 'teacher@email.com',
  name: 'teacher name',
  isTeacher: true
);

MyUser user = MyUser(
  userId: '1234', 
  email: 'example@user.com',
  name: 'example name',
  isTeacher: false
);

MyUserEntity userEntity = MyUserEntity(
        userId: '1234', 
        email: 'example@user.com',
        name: 'example name',
        isTeacher: false
);

Map<String, dynamic> userJson = {
  'userId': '1234',
  'email': 'example@user.com',
  'name': 'example name',
  'isTeacher': false
};