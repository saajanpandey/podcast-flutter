part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutPressed extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final LogoutModal logoutModal;
  LogoutSuccess({required this.logoutModal});
}

class LogoutError extends LogoutState {}
