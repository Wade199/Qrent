import 'dart:async';
import 'package:flutter/material.dart';
import 'myHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Déclaration des variables pour contrôler les animations.
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Démarrage de l'animation.
    _controller.forward();

    Timer(const Duration(seconds: 4),
            () => Navigator.pushReplacementNamed(context, "/myHomePage"));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bleu.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Center(
              child: Image(
                image: AssetImage("assets/Capture d’écran 2024-09-26 à 10.09.18.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}