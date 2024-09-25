import 'package:flutter/material.dart';
import 'package:qrent/emprunterPage.dart';
import 'myHomePage.dart';
import 'accueilPage.dart';
import 'restitutionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qrent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Qrent'),
      routes: {
        '/accueil': (context) => const AccueilPage(title: 'Accueil'),
        '/emprunter': (context) => const EmprunterPage(title: 'Emprunter'),
        '/restitution': (context) =>
            const RestitutionPage(title: 'Restitution'),
        //'/login': (context) => LoginPage(),
      },
    );
  }
}
