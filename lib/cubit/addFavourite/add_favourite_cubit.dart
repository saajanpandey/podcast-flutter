import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/AddFavouriteModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'add_favourite_state.dart';

class AddFavouriteCubit extends Cubit<AddFavouriteState> {
  AddFavouriteCubit() : super(AddFavouriteInitial());

  postFavourite(podcastId) async {
    final response = await getIt<ApiService>().addFavourite(podcastId);
    if (response?.status != null) {
      emit(AddFavouriteFetched(addFavouriteModal: response!));
    } else {
      emit(AddFavouriteError(addFavouriteModal: response!));
    }
  }
}
