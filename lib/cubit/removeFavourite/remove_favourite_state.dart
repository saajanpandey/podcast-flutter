part of 'remove_favourite_cubit.dart';

abstract class RemoveFavouriteState extends Equatable {
  const RemoveFavouriteState();

  @override
  List<Object> get props => [];
}

class RemoveFavouriteInitial extends RemoveFavouriteState {}

class RemoveFavouriteFetching extends RemoveFavouriteState {}

class RemoveFavouriteFetched extends RemoveFavouriteState {
  final RemoveFavouriteModel removeFavouriteModel;
  RemoveFavouriteFetched({required this.removeFavouriteModel});
}

class RemoveFavouriteError extends RemoveFavouriteState {
  final RemoveFavouriteModel removeFavouriteModel;
  RemoveFavouriteError({required this.removeFavouriteModel});
}
