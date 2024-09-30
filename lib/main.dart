import 'package:flutter/material.dart';
import 'package:qrent/emprunterPage.dart';
import 'SplashScreen.dart';
import 'myHomePage.dart';
import 'accueilPage.dart';
import 'restitutionPage.dart';
//import 'inscriptionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qrent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/accueil': (context) => const AccueilPage(title: ''),
        '/emprunter': (context) => const EmprunterPage(title: ''),
        '/restitution': (context) =>
            const RestitutionPage(title: ''),
        '/myHomePage': (context) =>
        const MyHomePage(title: ''),
        /*'/login': (BuildContext context) =>
            const MyHomePage(title: 'Connexion'),
        '/inscription': (BuildContext context) =>
            const InscriptionPage(title: 'Inscription'),*/
      },
    );
  }
}
