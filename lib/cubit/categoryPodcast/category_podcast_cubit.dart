import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/CategoryPodcastModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'category_podcast_state.dart';

class CategoryPodcastCubit extends Cubit<CategoryPodcastState> {
  CategoryPodcastCubit() : super(CategoryPodcastInitial());

  fetchFavouriteData(categoryId) async {
    emit(CategoryPodcastFetching());

    try {
      final response = await getIt<ApiService>().getCategoryPodcast(categoryId);
      if (response?.length != 0) {
        if (response != null) {
          emit(CategoryPodcastFetched(categoryPodcast: response));
        }
      } else {
        emit(CategoryPodcastNull());
      }
    } catch (e) {
      emit(CategoryPodcastError());
    }
  }
}
