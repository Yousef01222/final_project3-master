import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/auth/data/service/auth_service.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthService authService;
  int _retryCount = 0;
  static const int _maxRetries = 2;

  SignupCubit({required this.authService}) : super(SignupInitial());

  static SignupCubit get(context) => BlocProvider.of(context);

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String mobileNumber,
    required String gender,
    required String dob,
    File? profileImage,
    required String type,
    required int experienceYears,
  }) async {
    emit(SignupLoading());

    try {
      if (profileImage != null) {
        log('SignupCubit: Profile image included, size: ${await profileImage.length()} bytes');
      }

      final response = await authService.signup(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        mobileNumber: mobileNumber,
        gender: gender,
        dob: dob,
        profileImage: profileImage,
      );

      // Reset retry count on successful signup
      _retryCount = 0;

      log('SignupCubit: Signup successful, got response: ${response.message}');
      emit(SignupSuccess(response));
      log('SignupCubit: SignupSuccess state emitted');
    } catch (e) {
      log('SignupCubit: Error occurred during signup: $e');
      log(e.toString(), name: 'Signup Error');

      // Check if it's a timeout or server error (which might be temporary)
      if ((e.toString().contains('timeout') ||
              e.toString().contains('Gateway Timeout') ||
              e.toString().contains('503') ||
              e.toString().contains('502')) &&
          _retryCount < _maxRetries) {
        _retryCount++;
        log('SignupCubit: Retrying signup (Attempt $_retryCount of $_maxRetries)');

        // Emit a retry state
        emit(SignupRetrying(
            currentAttempt: _retryCount,
            maxAttempts: _maxRetries,
            errorMessage: "Server is busy. Retrying automatically..."));

        // Wait a bit before retrying
        await Future.delayed(const Duration(seconds: 2));

        // Retry signup without profile image if this was an image-related error
        bool imageError = e.toString().toLowerCase().contains('image') ||
            e.toString().contains('multipart') ||
            (profileImage != null && _retryCount == _maxRetries);

        return signup(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          mobileNumber: mobileNumber,
          gender: gender,
          dob: dob,
          profileImage: imageError ? null : profileImage,
          type: type,
          experienceYears: experienceYears,
        );
      } else if (profileImage != null &&
          (e.toString().contains('Internal Server Error') ||
              e.toString().toLowerCase().contains('image'))) {
        // If error seems related to image, try again without it
        log('SignupCubit: Image upload error detected, retrying without image');

        emit(SignupRetrying(
            currentAttempt: 1,
            maxAttempts: 1,
            errorMessage:
                "Image upload failed. Retrying without profile picture..."));

        await Future.delayed(const Duration(seconds: 1));

        return signup(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          mobileNumber: mobileNumber,
          gender: gender,
          dob: dob,
          profileImage: null,
          type: type,
          experienceYears: experienceYears,
        );
      } else {
        // Reset retry count
        _retryCount = 0;

        // For other errors or if retry limit reached, emit error state
        String errorMessage = e.toString();
        if (errorMessage.contains('504')) {
          errorMessage =
              'The server is temporarily unavailable. Please try again later.';
        } else if (errorMessage.contains('Internal Server Error') &&
            profileImage != null) {
          errorMessage =
              'Error uploading profile image. Please try again with a smaller image or without an image.';
        }

        emit(SignupError(errorMessage));
        log('SignupCubit: SignupError state emitted');
      }
    }
  }

  // Create translator profile
  Future<void> createTranslator({
    required String email,
    required File? certifications,
    required String languages,
    required String experienceYears,
    required String bio,
    required String types,
    required File? cv,
    required String location,
  }) async {
    log('SignupCubit: createTranslator method called');
    emit(TranslatorCreationLoading());

    try {
      log('SignupCubit: Calling authService.createTranslator');
      dynamic response;

      // First try the multipart approach for file uploads
      try {
        response = await authService.createTranslator(
          email: email,
          certifications: certifications,
          languages: languages,
          experienceYears: experienceYears,
          bio: bio,
          types: types,
          cv: cv,
          location: location,
        );
      } catch (e) {
        log('Multipart approach failed: $e');
        // If multipart fails, try the direct JSON approach
        log('Trying direct JSON approach without files');
        response = await authService.createTranslatorDirect(
          email: email,
          languages: languages,
          experienceYears: experienceYears,
          bio: bio,
          types: types,
          location: location,
        );
      }

      log('SignupCubit: Translator profile created successfully');
      emit(TranslatorCreationSuccess(response));
    } catch (e) {
      log('SignupCubit: Error occurred during translator creation: $e');
      log(e.toString(), name: 'Translator Creation Error');

      String errorMessage = e.toString();
      if (errorMessage.contains('504')) {
        errorMessage =
            'The server is temporarily unavailable. Please try again later.';
      }

      emit(TranslatorCreationError(errorMessage));
    }
  }
}
