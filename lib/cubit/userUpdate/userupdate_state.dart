part of 'userupdate_cubit.dart';

abstract class UserupdateState extends Equatable {
  const UserupdateState();

  @override
  List<Object> get props => [];
}

class UserupdateInitial extends UserupdateState {}

class UserupdateButtonPressed extends UserupdateState {}

class UserupdateSuccess extends UserupdateState {
  final UserProfileModal userProfileModal;
  UserupdateSuccess({required this.userProfileModal});
}

class UserupdateError extends UserupdateState {}
