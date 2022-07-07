part of 'profile_image_cubit.dart';

abstract class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object> get props => [];
}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImageButtonPressed extends ProfileImageState {}

class ProfileImageSuccess extends ProfileImageState {
  final ProfileImageModal profileImageModal;
  ProfileImageSuccess({required this.profileImageModal});
}

class ProfileImageError extends ProfileImageState {}
