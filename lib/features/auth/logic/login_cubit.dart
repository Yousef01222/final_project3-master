import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/auth/data/service/auth_service.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final response =
          await AuthService.login(email: email, password: password);

      if (response.message == 'User authenticated successfully' &&
          response.token != null) {
        // Store the token
        // await TokenStorageService.saveToken(response.token!);
        // prefs.setString('reciveId', response.);
        await TokenStorageService.saveToken(response.token!, response.userId!);

        log('Token saved: ${response.token}');
        log('Login successful: ${response.message}');
        emit(LoginSuccess(response));
      } else {
        log('Login failed: ${response.message}');
        emit(LoginError(response.message));
      }
    } catch (e) {
      emit(LoginError('Error: $e'));
    }
  }

  Future<void> logout() async {
    try {
      await TokenStorageService.clearToken();
      emit(LoginInitial());
    } catch (e) {
      log('Error during logout: $e');
      emit(LoginError('Error during logout: $e'));
    }
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      if (isLoggedIn) {
        emit(LoginAlreadyLoggedIn());
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      log('Error checking login status: $e');
      emit(LoginError('Error checking login status: $e'));
    }
  }
}
