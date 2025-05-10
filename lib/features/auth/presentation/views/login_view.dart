import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/core/widgets/custom_button.dart';
import 'package:grade3/features/auth/logic/login_cubit.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:grade3/features/auth/presentation/views/widgets/custom_textfield.dart';
import 'package:grade3/features/auth/presentation/views/widgets/custom_socialbutton.dart';
import 'package:grade3/features/auth/presentation/views/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess || state is LoginAlreadyLoggedIn) {
              // Navigate to home view for both successful login and already logged in states
              GoRouter.of(context).go(AppRouter.homeView);
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Color(0xFFB3E5FC), Colors.white],
                ),
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text("Login",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text("Login to your account",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.black54)),
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: _emailController,
                    labelText: "Email",
                    hintText: "Enter your email",
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    hintText: "Enter your password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  state is LoginLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: "Login",
                          onPressed: () {
                            cubit.loginUser(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: GoogleFonts.poppins()),
                      TextButton(
                        onPressed: () {
                          log("Navigation to SignUp triggered");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()),
                          );
                        },
                        child: Text("Sign Up",
                            style: GoogleFonts.poppins(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text("Or",
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ),
                  const SizedBox(height: 16),
                  CustomSocialButton(
                    text: "Continue with Google",
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
