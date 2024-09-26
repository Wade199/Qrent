import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EmprunterPage extends StatefulWidget {
  const EmprunterPage({super.key, required this.title});

  final String title;

  @override
  State<EmprunterPage> createState() => _EmprunterPageState();
}

class _EmprunterPageState extends State<EmprunterPage> {
  String? materielId;
  bool produitFound = false;
  Map<String, dynamic>? _produitData;
  TextEditingController _idController = TextEditingController();
  bool empruntValide = false;
  int etudiantId = 71;
  String? scannedQRCode;

  @override
  void initState() {
    super.initState();
  }

  fetchProduit(String id) async {
    try {
      print(id);
      final response = await http.get(
        Uri.parse(
            'https://s3-4295.nuage-peda.fr/Qrent/public/api/materiels/$id'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _produitData = convert.jsonDecode(response.body);
          produitFound = true;
          materielId = id;
        });
      } else {
        setState(() {
          produitFound = false;
          _produitData = null;
        });
        print('Produit non trouvé');
      }
    } catch (e) {
      print('Erreur lors de la recherche du produit: $e');
    }
  }

  Future<http.Response> validerEmprunt(
      int produitId, int etudiantId, String dateRetour) {
    return http.post(
      Uri.parse('https://s3-4295.nuage-peda.fr/Qrent/public/api/emprunts/'),
      headers: <String, String>{'Content-Type': 'application/ld+json'},
      body: convert.jsonEncode({
        'produit': produitId,
        'etudiant': etudiantId,
        'dateEmprunt': DateTime.now().toIso8601String(),
        'dateRetour': dateRetour,
        'status': true,
      }),
    );
  }

  Future<void> enregistrerEmprunt() async {
    if (_produitData != null) {
      var produitId = _produitData!['@id'];
      var dateRetour =
          DateTime.now().add(const Duration(days: 0)).toIso8601String();

      var response = await validerEmprunt(produitId, etudiantId, dateRetour);

      if (response.statusCode == 201) {
        setState(() {
          empruntValide = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Emprunt validé avec succès")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'emprunt")),
        );
        setState(() {
          empruntValide = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucun produit trouvé")),
      );
    }
  }
  /*
  Future<void> _scanQRCode() async {
    setState(() {
      scannedQRCode = "QR123456789"; 
    });
  }*/

  Widget buildProduitDetails() {
    if (produitFound && _produitData != null) {
      return Column(
        children: [
          Text(
            'Produit: ${_produitData!['nom']}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Référence: ${_produitData!['reference']}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      );
    } else if (_produitData == null) {
      return const Text(
        'Aucun produit trouvé pour cette référence',
        style: TextStyle(fontSize: 16),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //_scanQRCode();
              },
              child: const Text(
                "Scanner le QR code",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              scannedQRCode != null
                  ? "QR Code scanné: $scannedQRCode"
                  : "Aucun QR Code scanné",
              style: const TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: "Référence du produit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchProduit(_idController.text);
              },
              child: const Text(
                "Rechercher le produit",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 40),
            buildProduitDetails(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                enregistrerEmprunt();
              },
              child: const Text(
                "Valider l'emprunt",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
