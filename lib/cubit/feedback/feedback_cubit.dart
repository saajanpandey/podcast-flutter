import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:podcast/main.dart';
import 'package:podcast/modal/FeedbackModal.dart';
import 'package:podcast/services/ApiService.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  postFeedback(email, title, message) async {
    emit(FeedbackSending());
    final response =
        await getIt<ApiService>().feedbackregister(email, title, message);
    if (response?.status != null) {
      emit(FeedbackSuccess(feedbackModal: response!));
    } else {
      emit(FeedbackError(feedbackModal: response!));
    }
  }
}
