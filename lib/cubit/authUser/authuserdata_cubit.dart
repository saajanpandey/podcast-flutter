import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/AuthUserModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'authuserdata_state.dart';

class AuthuserdataCubit extends Cubit<AuthuserdataState> {
  AuthuserdataCubit() : super(AuthuserdataInitial());

  authUserCall() async {
    emit(AuthuserdataFetching());
    try {
      final response = await getIt<ApiService>().authUserdata();
      if (response?.message == null) {
        emit(AuthuserdataFetched(authData: response!));
      } else {
        emit(AuthuserdataError());
      }
    } catch (e) {
      emit(AuthuserdataError());
    }
  }
}
