part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordFetching extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final ChangePasswordModal changePasswordModal;
  ChangePasswordSuccess({required this.changePasswordModal});
}
class ChangePasswordError extends ChangePasswordState {}
