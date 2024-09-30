import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;
  late Timer _timer;

  int _currentPage = 0;
  List<Color> _colors = [Colors.blueAccent, Colors.blue, Colors.lightBlue];
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _pageController = PageController();

    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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


      body: Container(
        color: Colors.white70,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _colors[_currentColorIndex],
                    _colors[(_currentColorIndex + 1) % _colors.length],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),


            Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Bienvenue sur l'application Qrent !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),



                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Simplifiez vos emprunts et restitutions",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),


                      const SizedBox(height: 30),
                      SizedBox(
                        height: 150,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.asset(
                                'assets/image2.png',
                                fit: BoxFit.cover,
                              ),
                            ),


                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.asset(
                                'assets/image2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.asset(
                                'assets/image2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Choisissez une option ci-dessous pour commencer",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/emprunter');
                      },
                      child: const Text(
                        "Emprunter",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/restitution');
                      },
                      child: const Text(
                        "Restitution",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

    // Footer avec le logo
    Container(
    padding: const EdgeInsets.all(0),
    height: 100,
    width: double.infinity,
    child: Image.asset(
    'assets/BasDePage.png',
    fit: BoxFit.cover,
                          ),
    )],
                      ),
                    ]),
                  ],
                ),
      ));
  }
}