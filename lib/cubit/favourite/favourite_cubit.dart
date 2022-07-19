import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/PodcastModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  fetchFavouriteData() async {
    emit(FavouriteFetching());

    try {
      final response = await getIt<ApiService>().favouriteApi();
      if (response?.length != 0) {
        if (response != null) {
          emit(FavouriteFetched(podcastdata: response));
        }
      } else {
        emit(FavouriteNull());
      }
    } catch (e) {
      emit(FavouriteError());
    }
  }
}
