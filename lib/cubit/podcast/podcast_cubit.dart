import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/PodcastModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'podcast_state.dart';

class PodcastCubit extends Cubit<PodcastState> {
  PodcastCubit() : super(PodcastInitial());

  fetchPodcastData() async {
    emit(PodcastFetching());

    try {
      final response = await getIt<ApiService>().podcastApi();
      if (response != null) {
        emit(PodcastFetched(podcastdata: response));
      } else {
        emit(PodcastNull());
      }
    } catch (e) {
      emit(PodcastError());
    }
  }
}
