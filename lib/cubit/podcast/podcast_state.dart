part of 'podcast_cubit.dart';

abstract class PodcastState extends Equatable {
  const PodcastState();

  @override
  List<Object> get props => [];
}

class PodcastInitial extends PodcastState {}

class PodcastFetching extends PodcastState {}

class PodcastFetched extends PodcastState {
  final List<PodcastModal> podcastdata;
  PodcastFetched({required this.podcastdata});
  @override
  List<Object> get props => [podcastdata];
}

class PodcastNull extends PodcastState {}

class PodcastError extends PodcastState {}
