import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/LoginModal.dart';
import 'package:podcast/services/ApiService.dart';
import 'package:podcast/services/StorageService.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  postLogin(email, password) async {
    emit(LoginButtonPressed());

    final response = await getIt<ApiService>().login(email, password);
    if (response?.token != null) {
      StorageService().loginStatus(true, response?.token);
      emit(LoginSuccess(loginModal: response!));
    } else {
      emit(LoginError());
    }
  }
}
