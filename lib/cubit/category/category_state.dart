part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryFetching extends CategoryState {}

class CategoryNull extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryModal> category;
  CategorySuccess({required this.category});
  @override
  List<Object> get props => [category];
}

class CategoryError extends CategoryState {}
