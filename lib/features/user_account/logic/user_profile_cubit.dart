import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:grade3/features/user_account/data/services/user_profile_service.dart';
import 'package:grade3/features/user_account/logic/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileService _userProfileService = UserProfileService();

  UserProfileCubit() : super(UserProfileInitial());

  Future<void> getUserProfile() async {
    emit(UserProfileLoading());
    try {
      // Get token using TokenStorageService
      final token = await TokenStorageService.getToken();

      if (token == null) {
        emit(const UserProfileError('User not authenticated'));
        return;
      }

      final UserProfileModel userProfile =
          await _userProfileService.getUserProfile(token: token);
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}
