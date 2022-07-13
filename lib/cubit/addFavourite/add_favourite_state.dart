part of 'add_favourite_cubit.dart';

abstract class AddFavouriteState extends Equatable {
  const AddFavouriteState();

  @override
  List<Object> get props => [];
}

class AddFavouriteInitial extends AddFavouriteState {}

class AddFavouriteFetching extends AddFavouriteState {}

class AddFavouriteFetched extends AddFavouriteState {
  final AddFavouriteModal addFavouriteModal;
  AddFavouriteFetched({required this.addFavouriteModal});
}

class AddFavouriteError extends AddFavouriteState {
  final AddFavouriteModal addFavouriteModal;
  AddFavouriteError({required this.addFavouriteModal});
}
