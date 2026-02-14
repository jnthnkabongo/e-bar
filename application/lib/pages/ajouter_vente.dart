import 'package:flutter/material.dart';
import '../services/service.dart';

class AjouterVentePage extends StatefulWidget {
  const AjouterVentePage({super.key});

  @override
  State<AjouterVentePage> createState() => _AjouterVentePageState();
}

class _AjouterVentePageState extends State<AjouterVentePage> {
  final _formKey = GlobalKey<FormState>();
  final _prixController = TextEditingController();

  final List<Map<String, dynamic>> _venteItems = [];
  List<dynamic> _boissons = [];
  bool _isLoading = false;
  bool _isLoadingBoissons = true;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  double _totalGeneral = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadBoissons();
    // Ajouter une première ligne vide
    _addVenteItem();
  }

  @override
  void dispose() {
    _prixController.dispose();
    super.dispose();
  }

  // Ajouter un nouvel article à la vente
  void _addVenteItem() {
    setState(() {
      _venteItems.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'boissonId': null,
        'boisson': null,
        'quantite': 1,
        'quantiteController': TextEditingController(text: '1'),
        'prixUnitaire': 0.0,
        'sousTotal': 0.0,
        'sousTotalController': TextEditingController(text: '0.00'),
      });
    });
  }

  // Supprimer un article de la vente
  void _removeVenteItem(int itemId) {
    setState(() {
      _venteItems.removeWhere((item) => item['id'] == itemId);
      _calculateTotalGeneral();
    });
  }

  // Mettre à jour une boisson pour un article
  void _updateBoisson(int itemId, int? boissonId) {
    final boisson = boissonId != null
        ? _boissons.firstWhere((b) => b['id'] == boissonId, orElse: () => null)
        : null;

    setState(() {
      final item = _venteItems.firstWhere((item) => item['id'] == itemId);
      item['boissonId'] = boissonId;
      item['boisson'] = boisson;
      item['prixUnitaire'] =
          double.tryParse(boisson?['prix']?.toString() ?? '0') ?? 0.0;
      _calculateItemSousTotal(item);
    });
    _calculateTotalGeneral();
  }

  // Mettre à jour la quantité pour un article
  void _updateQuantite(int itemId, String quantite) {
    setState(() {
      final item = _venteItems.firstWhere((item) => item['id'] == itemId);
      item['quantite'] = int.tryParse(quantite) ?? 1;
      _calculateItemSousTotal(item);
    });
    _calculateTotalGeneral();
  }

  // Calculer le sous-total pour un article
  void _calculateItemSousTotal(Map<String, dynamic> item) {
    final quantite = item['quantite'] as int;
    final prixUnitaire = item['prixUnitaire'] as double;
    item['sousTotal'] = quantite * prixUnitaire;
    // Mettre à jour le controller du sous-total
    item['sousTotalController'].text = item['sousTotal'].toStringAsFixed(2);
  }

  // Calculer le total général
  void _calculateTotalGeneral() {
    _totalGeneral = _venteItems.fold(
      0.0,
      (sum, item) => sum + (item['sousTotal'] as double),
    );
    _prixController.text = _totalGeneral.toStringAsFixed(2);
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
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs dans le formulaire'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Valider que tous les articles ont une boisson sélectionnée
    final itemsInvalides = _venteItems
        .where((item) => item['boissonId'] == null)
        .toList();
    if (itemsInvalides.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez sélectionner une boisson pour chaque article',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Valider que tous les articles ont une quantité valide
    final quantitesInvalides = _venteItems
        .where((item) => item['quantite'] <= 0)
        .toList();
    if (quantitesInvalides.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Toutes les quantités doivent être supérieures à 0'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Début de la soumission avec ${_venteItems.length} articles');

      // Envoyer chaque article au backend
      List<Map<String, dynamic>> ventesData = [];
      for (var item in _venteItems) {
        print(
          'Article: boissonId=${item['boissonId']}, quantite=${item['quantite']}, prix=${item['prixUnitaire']}',
        );
        ventesData.add({
          'boisson_id': item['boissonId'],
          'quantite': item['quantite'],
          'prix_unitaire': item['prixUnitaire'],
        });
      }

      // Envoyer chaque vente individuellement
      bool allSuccess = true;
      String errorMessage = '';

      for (var venteData in ventesData) {
        print('Envoi de la vente: $venteData');
        final result = await ApiService.addVente(
          venteData['boisson_id'],
          venteData['quantite'],
          venteData['prix_unitaire'],
        );
        print('Résultat de l\'API: $result');

        if (!result['success']) {
          allSuccess = false;
          errorMessage = result['message'] ?? 'Erreur lors de la vente';
          print('Erreur détectée: $errorMessage');
          break;
        }
      }

      if (allSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Vente effectuée avec succès!\nTotal: ${_totalGeneral.toStringAsFixed(2)} FC',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        // Vider la liste des articles
        setState(() {
          _venteItems.clear();
          _addVenteItem(); // Ajouter un premier article vide
          _totalGeneral = 0.0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
        title: const Text('Effectuer une vente'),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header avec titre et bouton d'ajout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Articles de la vente',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_venteItems.length} article${_venteItems.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _addVenteItem,
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: 'Ajouter un article',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Liste des articles
                Expanded(
                  child: _isLoadingBoissons
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _venteItems.length,
                          itemBuilder: (context, index) {
                            final item = _venteItems[index];
                            return _buildVenteItemCard(item, index);
                          },
                        ),
                ),

                const SizedBox(height: 16),

                // Total général
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Général:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_totalGeneral.toStringAsFixed(2)} FC',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bouton de validation
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: (_isLoading || _venteItems.isEmpty)
                        ? null
                        : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Effectuer la vente',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget pour construire une carte d'article de vente attrayante
  Widget _buildVenteItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header de la carte
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Article ${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                const Spacer(),
                if (_venteItems.length > 1)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _removeVenteItem(item['id']),
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red.shade600,
                        size: 20,
                      ),
                      tooltip: 'Supprimer cet article',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Dropdown pour la boisson avec bouton +
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Boisson',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade400),
                ),
                prefixIcon: Icon(
                  Icons.local_drink,
                  color: Colors.blue.shade400,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              initialValue: item['boissonId'],
              isExpanded: true,
              items: _boissons.map((boisson) {
                return DropdownMenuItem<int>(
                  value: boisson['id'],
                  child: Text(
                    '${boisson['boisson']} - (${boisson['type_boisson'] ?? ''}) - (Prix: ${boisson['prix'] != null ? '${boisson['prix']} FC' : ''}) - (Stock: ${boisson['quantite_totale'] != null ? '${boisson['quantite_totale']}' : ''})',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }).toList(),
              onChanged: (value) => _updateBoisson(item['id'], value),
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner une boisson';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Ligne pour quantité et sous-total
            Row(
              children: [
                // Champ quantité
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: item['quantiteController'],
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade400),
                      ),
                      prefixIcon: Icon(
                        Icons.inventory,
                        color: Colors.blue.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateQuantite(item['id'], value),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Quantité requise';
                      }
                      if (int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Quantité > 0';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Sous-total (input lecture seule)
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: item['sousTotalController'],
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Sous-total FC',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      prefixIcon: Icon(
                        Icons.money,
                        color: Colors.green.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.green.shade50,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
