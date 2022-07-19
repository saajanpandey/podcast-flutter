import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/RemoveFavouriteModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'remove_favourite_state.dart';

class RemoveFavouriteCubit extends Cubit<RemoveFavouriteState> {
  RemoveFavouriteCubit() : super(RemoveFavouriteInitial());

  remove(id) async {
    emit(RemoveFavouriteFetching());
    final response = await getIt<ApiService>().removeFavourite(id);
    if (response?.status != null) {
      emit(RemoveFavouriteFetched(removeFavouriteModel: response!));
    } else {
      emit(RemoveFavouriteError(removeFavouriteModel: response!));
    }
  }
}
