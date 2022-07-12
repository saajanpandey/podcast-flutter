part of 'feedback_cubit.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackSending extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {
  final FeedbackModal feedbackModal;
  FeedbackSuccess({required this.feedbackModal});
}

class FeedbackError extends FeedbackState {
  final FeedbackModal feedbackModal;
  FeedbackError({required this.feedbackModal});
}
