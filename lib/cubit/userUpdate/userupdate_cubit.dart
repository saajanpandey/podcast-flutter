import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/UserProfileModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'userupdate_state.dart';

class UserupdateCubit extends Cubit<UserupdateState> {
  UserupdateCubit() : super(UserupdateInitial());

  userUpdate(fullname, dateofbirth, gender) async {
    emit(UserupdateButtonPressed());
    final response =
        await getIt<ApiService>().authUserUpdate(fullname, dateofbirth, gender);
    if (response?.status != null) {
      emit(UserupdateSuccess(userProfileModal: response!));
    } else {
      emit(UserupdateError());
    }
  }
}
