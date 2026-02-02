import 'package:flutter/material.dart';
import '../services/service.dart';

class AjouterTypeBoissonPage extends StatefulWidget {
  const AjouterTypeBoissonPage({super.key});

  @override
  State<AjouterTypeBoissonPage> createState() => _AjouterTypeBoissonPageState();
}

class _AjouterTypeBoissonPageState extends State<AjouterTypeBoissonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  bool _isLoading = false;
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final profileResult = await ApiService.getProfile();

      setState(() {
        userData = profileResult['success']
            ? profileResult['data']['user']
            : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  // Fonction pour obtenir l'initiale de l'utilisateur
  String _getUserInitial() {
    if (userData != null && userData!['name'] != null) {
      String name = userData!['name'].toString();
      if (name.isNotEmpty) {
        return name[0].toUpperCase();
      }
    }
    return 'U'; // 'U' pour User par défaut
  }

  // Fonction pour obtenir le nom complet de l'utilisateur
  String _getUserName() {
    if (userData != null && userData!['name'] != null) {
      return userData!['name'].toString();
    }
    return 'Utilisateur';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.addTypeBoisson(
        _nomController.text.trim(),
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Type de boisson ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erreur lors de l\'ajout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un type de boisson'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Tooltip(
              message: _getUserName(),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  _getUserInitial(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du type de boisson',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_drink),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ajouter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
