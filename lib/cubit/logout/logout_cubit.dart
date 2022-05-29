import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/LogoutModal.dart';
import 'package:podcast/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    emit(LogoutPressed());
    final response = await getIt<ApiService>().logout();
    if (response?.message != null) {
      prefs.remove('status');
      prefs.remove('token');
      emit(LogoutSuccess(logoutModal: response!));
    } else {
      emit(LogoutError());
    }
  }
}
