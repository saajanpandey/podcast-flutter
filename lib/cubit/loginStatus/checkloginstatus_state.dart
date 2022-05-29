part of 'checkloginstatus_cubit.dart';

abstract class CheckloginstatusState extends Equatable {
  const CheckloginstatusState();

  @override
  List<Object> get props => [];
}

class CheckloginstatusInitial extends CheckloginstatusState {}

class CheckloginstatusChecking extends CheckloginstatusState {}

class CheckloginstatusTrue extends CheckloginstatusState {}

class CheckloginstatusFalse extends CheckloginstatusState {}
