import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpLoading());
      try {
        MyUser myUser = await _userRepository.signUp(event.user, event.password);

        await _userRepository.setUserData(myUser);
        emit(SignUpSuccess());
      } catch (e) {
         String errorMessage = e.toString();
        int colonIndex = errorMessage.indexOf(':');
        if (colonIndex != -1 && colonIndex + 1 < errorMessage.length) {
          errorMessage = errorMessage.substring(colonIndex + 1).trim();
        }
        emit(SignUpFailure(error: errorMessage));
      }
    });
  }
}