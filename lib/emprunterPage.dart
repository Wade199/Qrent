import 'package:flutter/material.dart';

class EmprunterPage extends StatefulWidget {
  const EmprunterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EmprunterPage> createState() => _EmprunterPageState();
}

class _EmprunterPageState extends State<EmprunterPage> {
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
            /*children: [
            Image.asset('assets/LogoEPSIentete.png'),
          ],*/
            ),
      ),
    );
  }
}
