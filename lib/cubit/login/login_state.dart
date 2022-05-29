part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginButtonPressed extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModal loginModal;
  LoginSuccess({required this.loginModal});
}

class LoginError extends LoginState {
  
}
