import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/LoginModal.dart';
import 'package:podcast/modal/RegisterModal.dart';
import 'package:podcast/services/ApiService.dart';
import 'package:podcast/services/StorageService.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  postRegister(fullname, dateOfBirth, gender, email, password) async {
    emit(RegisterButtonPressed());
    final response = await getIt<ApiService>()
        .register(fullname, dateOfBirth, gender, email, password);
    if (response?.token != null) {
      StorageService().loginStatus(true, response?.token);
      emit(RegisterSuccess(registerModal: response!));
    } else {
      emit(RegisterError(registerModal: response!));
    }
  }
}
