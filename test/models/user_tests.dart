import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';
import '../factories/user_factory.dart';

void userTest(){
  group('Test Constructor', () {
    test('Create a Student User', () {
      expect(student.userId, '1234');
      expect(student.email, 'student@email.com');
      expect(student.name, 'student name');
      expect(student.isTeacher, false);
    });
    test('Create a Teacher User', () {
      expect(teacher.userId, '1234');
      expect(teacher.email, 'teacher@email.com');
      expect(teacher.name, 'teacher name');
      expect(teacher.isTeacher, true);
    });
  });
  group('Test Conversion to Entity and Reading from Entity', () {
    test('Convert to Entity', () {
      final userEntity = user.toEntity();

      expect(userEntity.userId, '1234');
      expect(userEntity.email, 'example@user.com');
      expect(userEntity.name, 'example name');
      expect(userEntity.isTeacher, false);
    });

    test('Convert from Entity', () {
      final user = MyUser.fromEntity(userEntity);

      expect(user.userId, '1234');
      expect(user.email, 'example@user.com');
      expect(user.name, 'example name');
      expect(user.isTeacher, false);
    });

    test('Convert to String', () {
      final userString = user.toString();

      expect(userString, 'MyUser: ${user.userId}, ${user.email}, ${user.name}, ${user.isTeacher}');
    });

    test('Convert Entity to JSON', () {
      final userJson = userEntity.toJson();

      expect(userJson['userId'], '1234');
      expect(userJson['email'], 'example@user.com');
      expect(userJson['name'], 'example name');
      expect(userJson['isTeacher'], false);
    });

    test('Convert JSON to Entity', () {
      final userEntity = MyUserEntity.fromJson(userJson);

      expect(userEntity.userId, '1234');
      expect(userEntity.email, 'example@user.com');
      expect(userEntity.name, 'example name');
      expect(userEntity.isTeacher, false);
    });
  });
}