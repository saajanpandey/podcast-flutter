part of 'category_podcast_cubit.dart';

abstract class CategoryPodcastState extends Equatable {
  const CategoryPodcastState();

  @override
  List<Object> get props => [];
}

class CategoryPodcastInitial extends CategoryPodcastState {}

class CategoryPodcastFetching extends CategoryPodcastState {}

class CategoryPodcastFetched extends CategoryPodcastState {
  final List<CategoryPodcastModal> categoryPodcast;
  CategoryPodcastFetched({required this.categoryPodcast});
  @override
  List<Object> get props => [categoryPodcast];
}

class CategoryPodcastError extends CategoryPodcastState {}

class CategoryPodcastNull extends CategoryPodcastState {}
