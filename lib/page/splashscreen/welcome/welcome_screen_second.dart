import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frank_salazar/main.dart';
import 'package:frank_salazar/page/splashscreen/share/app_asset.dart';

class WelcomeScreenSecond extends StatefulWidget {
  static String route = 'bienvenida-screen-second';

  const WelcomeScreenSecond({super.key});

  @override
  State<WelcomeScreenSecond> createState() => _WelcomeScreenSecondState();
}

class _WelcomeScreenSecondState extends State<WelcomeScreenSecond>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    initAnimator();
    autoRedirectToHomeScreen();
  }

  void initAnimator() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoRotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1, curve: Curves.easeOut),
    );

    _textAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.65, 1, curve: Curves.easeIn),
    );

    // Inicia el proceso de animación para los objetos
    _animationController.forward();
  }

  void autoRedirectToHomeScreen() {
    Future.delayed(const Duration(milliseconds: 3000),
        () => Navigator.pushNamed(context, MyHomePage.route));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005EFF),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Opacity(
                      opacity: _textAnimation.value,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.3, 0.0),
                          end: const Offset(0.1, 0.0),
                        ).animate(_textAnimation),
                      ),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0.0),
                        end: Offset.zero,
                      ).animate(_logoAnimation),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..rotateY(_logoRotationAnimation.value * 2 * pi),
                        alignment: Alignment.center,
                        child: Container(
                          color: const Color(0xFF005EFF),
                          child: Image.asset(
                            AppAsset.logoSecondary,
                            width: 200.0,
                            height: 90.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
