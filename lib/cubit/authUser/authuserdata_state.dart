part of 'authuserdata_cubit.dart';

abstract class AuthuserdataState extends Equatable {
  const AuthuserdataState();

  @override
  List<Object> get props => [];
}

class AuthuserdataInitial extends AuthuserdataState {}

class AuthuserdataFetching extends AuthuserdataState {}

class AuthuserdataFetched extends AuthuserdataState {
  final AuthUserModal authData;
  AuthuserdataFetched({required this.authData});
}

class AuthuserdataError extends AuthuserdataState {}
