import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/services/StorageService.dart';

part 'checkloginstatus_state.dart';

class CheckloginstatusCubit extends Cubit<CheckloginstatusState> {
  CheckloginstatusCubit() : super(CheckloginstatusInitial());

  checkStatus() async {
    emit(CheckloginstatusChecking());
    var loginstatus = await StorageService().getLoginStatus();
    if (loginstatus == true) {
      emit(CheckloginstatusTrue());
    } else {
      emit(CheckloginstatusFalse());
    }
  }
}
