part of 'favourite_cubit.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteFetching extends FavouriteState {}

class FavouriteFetched extends FavouriteState {
  final List<PodcastModal> podcastdata;
  FavouriteFetched({required this.podcastdata});
  @override
  List<Object> get props => [podcastdata];
}

class FavouriteError extends FavouriteState {}

class FavouriteNull extends FavouriteState {}
