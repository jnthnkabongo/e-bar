import 'package:flutter/material.dart';
import '../services/service.dart';

class AjouterVentePage extends StatefulWidget {
  const AjouterVentePage({super.key});

  @override
  State<AjouterVentePage> createState() => _AjouterVentePageState();
}

class _AjouterVentePageState extends State<AjouterVentePage> {
  final _formKey = GlobalKey<FormState>();
  final _quantiteController = TextEditingController();
  final _prixController = TextEditingController();

  int? _selectedBoissonId;
  List<dynamic> _boissons = [];
  bool _isLoading = false;
  bool _isLoadingBoissons = true;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? _selectedBoisson;
  double _calculatedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadBoissons();

    // Ajouter un écouteur pour le champ quantité
    _quantiteController.addListener(_calculatePrice);
  }

  @override
  void dispose() {
    _quantiteController.removeListener(_calculatePrice);
    _quantiteController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  // Fonction pour calculer le prix automatiquement
  void _calculatePrice() {
    if (_selectedBoisson != null && _quantiteController.text.isNotEmpty) {
      final quantite = int.tryParse(_quantiteController.text) ?? 0;
      final prixUnitaire =
          double.tryParse(_selectedBoisson!['prix']?.toString() ?? '0') ?? 0.0;

      setState(() {
        _calculatedPrice = quantite * prixUnitaire;
        _prixController.text = _calculatedPrice.toStringAsFixed(2);
      });
    }
  }

  // Fonction pour mettre à jour la boisson sélectionnée
  void _updateSelectedBoisson(int? boissonId) {
    final boisson = _boissons.firstWhere(
      (b) => b['id'] == boissonId,
      orElse: () => null,
    );

    setState(() {
      _selectedBoissonId = boissonId;
      _selectedBoisson = boisson;
    });

    // Recalculer le prix si une quantité est déjà entrée
    _calculatePrice();
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
    return 'U';
  }

  // Fonction pour obtenir le nom complet de l'utilisateur
  String _getUserName() {
    if (userData != null && userData!['name'] != null) {
      return userData!['name'].toString();
    }
    return 'Utilisateur';
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
      final quantite = int.tryParse(_quantiteController.text) ?? 0;
      final prixUnitaire =
          double.tryParse(_selectedBoisson!['prix']?.toString() ?? '0') ?? 0.0;

      final result = await ApiService.addVente(
        _selectedBoissonId!,
        quantite,
        prixUnitaire, // Envoyer le prix unitaire au backend
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Vente effectuée avec succès!\n',
              // 'Montant total: ${result['montant_total']} \$\n'
              // 'Stock restant: ${result['stock_restant']} unités',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        // Vider le formulaire
        _formKey.currentState?.reset();
        _quantiteController.clear();
        _prixController.clear();
        setState(() {
          _selectedBoissonId = null;
          _selectedBoisson = null;
          _calculatedPrice = 0.0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erreur lors de la vente'),
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
        title: const Text('Ajouter une vente'),
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
                            '${boisson['boisson']} - ${boisson['type_boisson'] ?? ''} (Stock: ${boisson['quantite_totale'] ?? 0})',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _updateSelectedBoisson(value);
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _prixController,
                enabled: false, // Rendre le champ grisé
                decoration: InputDecoration(
                  labelText: 'Prix total (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  helperText: _selectedBoisson != null
                      ? 'Prix unitaire: ${double.tryParse(_selectedBoisson!['prix']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'} \$'
                      : 'Sélectionnez une boisson et entrez une quantité',
                  helperStyle: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Le stock sera automatiquement déduit après la vente',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: 8),
                          Text(
                            'Effectuer la vente',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
