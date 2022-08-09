import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/CategoryModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  categoryData() async {
    emit(CategoryFetching());

    try {
      final response = await getIt<ApiService>().getCategory();
      if (response?.length != 0) {
        if (response != null) {
          emit(CategorySuccess(category: response));
        }
      } else {
        emit(CategoryNull());
      }
    } catch (e) {
      emit(CategoryError());
    }
  }
}
