import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/ProfileImageModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit() : super(ProfileImageInitial());

  imageUpdate(image) async {
    emit(ProfileImageButtonPressed());

    final response = await getIt<ApiService>().imageUpload(image);
    if (response.status != null) {
      emit(ProfileImageSuccess(profileImageModal: response));
    } else {
      emit(ProfileImageError());
    }
  }
}
