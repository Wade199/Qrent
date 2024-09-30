
import 'dart:ffi'; //
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EmprunterPage extends StatefulWidget {
  const EmprunterPage({super.key, required this.title});

  final String title;

  @override
  State<EmprunterPage> createState() => _EmprunterPageState();
}

class _EmprunterPageState extends State<EmprunterPage> with SingleTickerProviderStateMixin {
  String? materielId;
  bool produitFound = false;
  Map<String, dynamic>? _produitData;
  TextEditingController _idController = TextEditingController();
  bool empruntValide = false;
  int etudiantId = 71;
  String? scannedQRCode;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur d'animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // Création d'une animation de fondu
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  // Fonction pour récupérer les données du produit à partir de l'API
  fetchProduit(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://s3-4295.nuage-peda.fr/Qrent/public/api/materiels/$id'),
      );
      // Vérifie si la requête a réussi
      if (response.statusCode == 200) {
        setState(() {
          // Met à jour l'état avec les données du produit
          _produitData = convert.jsonDecode(response.body);
          produitFound = true;
          materielId = id;
        });
      } else {
        setState(() {
          produitFound = false;
          _produitData = null;
        });
      }
    } catch (e) {
      print('Erreur lors de la recherche du produit: $e');
    }
  }

  // Fonction pour valider l'emprunt en envoyant une requête POST à l'API
  Future<http.Response> validerEmprunt(int produitId, int etudiantId, String dateRetour) {
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

  // Fonction pour enregistrer l'emprunt
  Future<void> enregistrerEmprunt() async {
    if (_produitData != null) {
      var produitId = _produitData!['@id'];
      var dateRetour = DateTime.now().add(const Duration(days: 0)).toIso8601String();

      var response = await validerEmprunt(produitId, etudiantId, dateRetour);

      // Vérifie si la requête a réussi
      if (response.statusCode == 201) {
        setState(() {
          empruntValide = true;
        });
        // Affiche un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Emprunt validé avec succès")),
        );
      } else {
        // Affiche un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'emprunt")),
        );
        setState(() {
          empruntValide = false;
        });
      }
    } else {
      // Affiche un message si aucun produit n'est trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucun produit trouvé")),
      );
    }
  }


  Widget buildProduitDetails() {
    if (produitFound && _produitData != null) {
      return Column(
        children: [
          Text(
            'Produit: ${_produitData!['nom']}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Référence: ${_produitData!['reference']}',
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ],
      );
    } else if (_produitData == null) {
      return const Text(
        'Aucun produit trouvé pour cette référence',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else {
      return const CircularProgressIndicator();
    }
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
            color: Colors.blueAccent,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Titre
                    Column(
                      children: [
                        Text(
                          "Bienvenue dans notre section d'emprunt de matériel !",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    // Champ de texte et bouton de recherche
                    Column(
                      children: [
                        TextField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: "Référence du produit",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            fetchProduit(_idController.text);
                          },
                          child: const Text(
                            "Rechercher le produit",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Section QR Code
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // _scanQRCode();
                          },
                          child: const Text(
                            "Scanner le QR code",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          scannedQRCode != null
                              ? "QR Code scanné: $scannedQRCode"
                              : "Aucun QR Code scanné",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
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