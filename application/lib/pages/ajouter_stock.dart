import 'package:flutter/material.dart';
import '../services/service.dart';

class AjouterStockPage extends StatefulWidget {
  const AjouterStockPage({super.key});

  @override
  State<AjouterStockPage> createState() => _AjouterStockPageState();
}

class _AjouterStockPageState extends State<AjouterStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantiteController = TextEditingController();

  int? _selectedBoissonId;
  List<dynamic> _boissons = [];
  bool _isLoading = false;
  bool _isLoadingBoissons = true;
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadBoissons();
    _loadData();
  }

  @override
  void dispose() {
    _quantiteController.dispose();
    super.dispose();
  }

  Future<void> _loadBoissons() async {
    try {
      final result = await ApiService.getBoissons();
      if (result['success']) {
        setState(() {
          _boissons = result['data']['boissons'] ?? [];
          _isLoadingBoissons = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingBoissons = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de chargement des boissons: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    if (!_formKey.currentState!.validate() || _selectedBoissonId == null) {
      if (_selectedBoissonId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une boisson'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.addStock(
        _selectedBoissonId!,
        int.tryParse(_quantiteController.text) ?? 0,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stock ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Erreur lors de l\'ajout du stock',
            ),
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
        title: const Text('Ajouter du stock'),
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
              _isLoadingBoissons
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Boisson',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_drink),
                      ),
                      value: _selectedBoissonId,
                      items: _boissons.map((boisson) {
                        return DropdownMenuItem<int>(
                          value: boisson['id'],
                          child: Text(
                            '${boisson['boisson']} - ${boisson['type_boisson'] ?? ''}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBoissonId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une boisson';
                        }
                        return null;
                      },
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantiteController,
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  if (int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Veuillez entrer une quantité valide';
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
