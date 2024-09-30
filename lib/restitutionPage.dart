import 'package:flutter/material.dart';

class RestitutionPage extends StatefulWidget {
  const RestitutionPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RestitutionPage> createState() => _RestitutionPageState();
}

class _RestitutionPageState extends State<RestitutionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SizedBox(
              height: 80,
              child: Image.asset(
                'assets/Capture d’écran 2024-09-26 à 10.09.18.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue[800],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bienvenue sur la page de restitution !",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Veuillez suivre les instructions pour restituer le matériel.",
                          style: const TextStyle(fontSize: 18,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {

                          },
                          child: const Text(
                            "Restituer le matériel",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              width: double.infinity,
              child: Image.asset(
                'assets/BasDePage.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }}