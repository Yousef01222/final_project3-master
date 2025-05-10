import 'package:go_router/go_router.dart';
import 'package:grade3/features/auth/presentation/views/forgot_password_view.dart';
import 'package:grade3/features/auth/presentation/views/sendcode_view.dart';
import 'package:grade3/features/auth/presentation/views/signup_view.dart';
import 'package:grade3/features/chat/presentation/views/chat_view.dart';
import 'package:grade3/features/company_profile/presentation/views/company_profile_view.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/views/home_view.dart';
import 'package:grade3/features/translator_profile/presentation/views/translator_profile_view.dart';
import 'package:grade3/core/services/token_storage_service.dart';

// استيراد LoginView باسم مختلف لتجنب الـ ambiguous import
import 'package:grade3/features/auth/presentation/views/login_view.dart'
    as auth;

abstract class AppRouter {
  static const homeView = '/homeView';
  static const signUpView = '/signUpView';
  static const forgotPasswordView = '/forgotPasswordView';
  static const sendCodeView = '/sendCodeView';
  static const companyProfileView = '/companyProfileView';
  static const profileView = '/profileView';
  static const chatView = '/chatView';
  static const loginView = '/';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      final isLoginRoute = state.matchedLocation == loginView;

      if (!isLoggedIn && !isLoginRoute) {
        return loginView;
      }

      if (isLoggedIn && isLoginRoute) {
        return homeView;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const auth.LoginView(),
      ),
      GoRoute(
        path: signUpView,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: homeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: forgotPasswordView,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: sendCodeView,
        builder: (context, state) => SendCodeView(
          email: state.extra as String,
        ),
      ),
      GoRoute(
        path: companyProfileView,
        builder: (context, state) =>
            CompanyProfileView(companyModel: state.extra as CompanyModel),
      ),
      GoRoute(
        path: profileView,
        builder: (context, state) => TranslatorProfileView(
          translatorModel: state.extra as TranslatorModel,
        ),
      ),
      GoRoute(
        path: chatView,
        builder: (context, state) => const ChatView(),
      ),
    ],
  );
}
