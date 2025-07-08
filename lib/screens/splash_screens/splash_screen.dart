
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:supermarket_app_03072025/onboarding_screen.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/image.png'),
      backgroundColor: AppColors.background, // #F5F5F5
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
      nextScreen: const OnBoardingScreen(),
    );
  }
}