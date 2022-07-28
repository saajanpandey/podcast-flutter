import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/ChangePasswordModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  changePassword(oldPassword, newPassword, confirmPassword) async {
    emit(ChangePasswordFetching());

    final response = await getIt<ApiService>()
        .changePassword(oldPassword, newPassword, confirmPassword);
    if (response?.status != null) {
      emit(ChangePasswordSuccess(changePasswordModal: response!));
    } else {
      emit(ChangePasswordError());
    }
  }
}
