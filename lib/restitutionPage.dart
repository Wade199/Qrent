import 'package:flutter/material.dart';

class RestitutionPage extends StatefulWidget {
  const RestitutionPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RestitutionPage> createState() => _RestitutionPageState();
}

class _RestitutionPageState extends State<RestitutionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
