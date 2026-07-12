//lib/features/profile/presentation/profile_screen.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple Profile model used by the cubit.
/// Replace or extend with your domain model as needed.
class Profile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}

/// Abstract repository interface.
/// Implement this in the data layer and inject into the cubit.
abstract class ProfileRepository {
  Future<Profile> fetchProfile(String userId);
  Future<Profile> updateProfile(Profile profile);
  Future<void> signOut();
}

/// Status enum for the state.
enum ProfileStatus { initial, loading, success, failure }

/// State for ProfileCubit.
class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  factory ProfileState.initial() =>
      const ProfileState(status: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}

/// Cubit responsible for profile-related actions.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileState.initial());

  /// Loads a profile by userId.
  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    try {
      final profile = await repository.fetchProfile(userId);
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Updates profile. Emits loading then success or failure.
  Future<void> updateProfile(Profile updated) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    try {
      final profile = await repository.updateProfile(updated);
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Signs out the user and resets state to initial.
  Future<void> signOut() async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    try {
      await repository.signOut();
      emit(ProfileState.initial());
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }
}