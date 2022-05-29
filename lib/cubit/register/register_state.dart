part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterButtonPressed extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterModal registerModal;
  RegisterSuccess({required this.registerModal});
}

class RegisterError extends RegisterState {
  final RegisterModal registerModal;
  RegisterError({required this.registerModal});
}
