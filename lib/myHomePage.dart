import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Durée de l'animation
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

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
        elevation: 0,
        flexibleSpace: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SizedBox(
              height: 80,
              child: Image.asset(
                "assets/Capture d’écran 2024-09-26 à 10.09.18.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bleu.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                height: 500,
                width: 500,
                child: Image(
                  image: AssetImage('assets/Qrent Logo.png'),
                ),
              ),
            ),
            const SizedBox(height: 50),
    ElevatedButton(
    onPressed: () {
    Navigator.pushNamed(context, '/accueil');
    },
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.blueAccent,
    backgroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 10,
    shadowColor: Colors.black45,
    ),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
    Icon(Icons.login, size: 24),
    SizedBox(width: 8),
    Text(
    "Se connecter",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    ],
    ),
    )])));}
  }