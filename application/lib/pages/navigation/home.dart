import 'package:application/services/service.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? dashboardData;
  List<dynamic>? _stockDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profileResult = await ApiService.getProfile();
      final dashboardResult = await ApiService.getDashboard();
      final stocksResult = await ApiService.getStocks();

      setState(() {
        userData = profileResult['success']
            ? profileResult['data']['user']
            : null;
        dashboardData = dashboardResult['success']
            ? dashboardResult['data']
            : null;
        _stockDetails = stocksResult['success']
            ? stocksResult['data']['stocks']
            : [];
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

  // Fonction pour regrouper les stocks par type de boisson
  Map<String, int> _getStockByType() {
    Map<String, int> stockByType = {};

    if (_stockDetails != null) {
      for (var stock in _stockDetails!) {
        String typeBoisson =
            stock['boisson']['type_boisson']['type'] ?? 'Non défini';
        int quantite = stock['quantite'] ?? stock['quantite_actuelle'] ?? 0;

        if (stockByType.containsKey(typeBoisson)) {
          stockByType[typeBoisson] = stockByType[typeBoisson]! + quantite;
        } else {
          stockByType[typeBoisson] = quantite;
        }
      }
    }

    return stockByType;
  }

  // Fonction pour afficher les stocks par type depuis le dashboard
  String _getStocksParTypeDisplay() {
    if (dashboardData?['stats']?['stocks_par_type'] == null) {
      return '0 types';
    }

    List<dynamic> stocksParType = dashboardData!['stats']['stocks_par_type'];
    if (stocksParType.isEmpty) {
      return '0 types';
    }

    // Créer une liste des types avec leurs quantités
    List<String> typesAvecQuantites = [];

    for (var stock in stocksParType) {
      String type = (stock['type_boisson'] ?? 'N/A').toString().toUpperCase();
      int quantite = stock['quantite_totale'] ?? 0;
      typesAvecQuantites.add('$type: $quantite');
    }

    // Joindre tous les types avec des virgules
    return typesAvecQuantites.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        // Avatar utilisateur à droite
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bonjour, ${userData?['name'] ?? 'Utilisateur'} 👋",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Rôle : ${userData?['role_name'] ?? 'Non défini'}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Grille des statistiques
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      DashboardCard(
                        title: "Valeur du stock en chiffre initial",
                        value:
                            "${dashboardData?['stats']?['somme_prix_quantite_initiale'] ?? '0'} FC",
                        icon: Icons.pie_chart,
                        color: Colors.green,
                      ),
                      DashboardCard(
                        title: "Valeur du stock en chiffre actuel",
                        value:
                            "${dashboardData?['stats']?['somme_prix_quantite_actuel'] ?? '0'} FC",
                        icon: Icons.remove,
                        color: Colors.redAccent,
                      ),

                      DashboardCard(
                        title: "Stock total actuel",
                        value:
                            "${dashboardData?['stats']?['total_stock'] ?? '0'}",
                        icon: Icons.inventory_2,
                        color: Colors.orange,
                      ),
                      DashboardCard(
                        title: "Quantité vendue aujourd'hui",
                        value:
                            "${dashboardData?['stats']?['total_vendu'] ?? '0'}",
                        icon: Icons.shopping_cart,
                        color: Colors.indigo,
                      ),
                      DashboardCard(
                        title: "Utilisateurs",
                        value:
                            "${dashboardData?['stats']?['total_utilisateurs'] ?? '0'}",
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                      DashboardCard(
                        title: "Total ventes par bouteille",
                        value:
                            "${dashboardData?['stats']?['total_vente'] ?? '0'}",
                        icon: Icons.trending_up_outlined,
                        color: Colors.red,
                      ),
                      DashboardCard(
                        title: "Montant des ventes",
                        value:
                            "${dashboardData?['stats']?['somme_vente_today'] ?? '0'} FC",
                        icon: Icons.money_sharp,
                        color: Colors.teal,
                      ),
                      // DashboardCard(
                      //   title: "Quantité boisson par type",
                      //   value: _getStocksParTypeDisplay(),
                      //   icon: Icons.collections_bookmark_outlined,
                      //   color: Colors.amberAccent,
                      // ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Section Stock par type de boissons
                  const Text(
                    "Stock par type de boissons",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (dashboardData?['stats']?['stocks_par_type'] != null)
                          ...dashboardData!['stats']['stocks_par_type'].map<
                            Widget
                          >((stock) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (stock['type_boisson'] ?? 'N/A')
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${stock['quantite_totale'] ?? 0} Bouteilles",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                        else
                          const Center(
                            child: Text(
                              "Aucune donnée de stock disponible",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Section résumé
                  const Text(
                    "Résumé du jour",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SummaryRow(
                          label: "Boisson la plus vendue",
                          value: "Bière Primus",
                        ),
                        SizedBox(height: 10),
                        SummaryRow(
                          label: "Serveur le plus actif",
                          value: "Jean Mukendi",
                        ),
                        SizedBox(height: 10),
                        SummaryRow(label: "Dépenses", value: "230 \$"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 50),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const SummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
