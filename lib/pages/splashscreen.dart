import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white]),
        childWidget: SizedBox(
            height: 100, child: Image.asset('assets/case_logo_main.ico')),
        duration: const Duration(milliseconds: 1500),
        animationDuration: const Duration(milliseconds: 1000),
        onEnd: () => context.replace(Routes.wrapper));
  }
}
