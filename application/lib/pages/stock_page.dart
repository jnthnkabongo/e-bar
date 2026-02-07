import 'package:application/pages/ajouter_stock.dart';
import 'package:application/pages/ajouter_type_boisson.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'ajouter_boisson.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<dynamic> stocks = [];
  List<dynamic> boissons = [];
  List<dynamic> sommeParType = [];
  bool isLoading = true;
  int sommeStock = 0;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadStocks();
    _loadData();
  }

  Future<void> _loadStocks() async {
    try {
      final result = await ApiService.getStocks();
      if (result['success']) {
        setState(() {
          stocks = result['data']['stock'] ?? [];
          sommeStock =
              int.tryParse(result['data']['sommeStock'].toString()) ?? 0;
          sommeParType = result['data']['sommeParType'] ?? [];
          isLoading = false;
          print(sommeStock);
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

  void _showActions(Map<String, dynamic> boisson) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Modifier quantité'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, int> getTotals() {
    Map<String, int> totals = {};
    for (var stock in stocks) {
      var boisson = stock['boisson'];
      if (boisson != null && boisson['type_boisson'] != null) {
        String type = boisson['type_boisson']['type'] ?? 'Non défini';
        totals[type] =
            (totals[type] ?? 0) + (stock['quantite_actuelle'] as int);
      }
    }
    return totals;
  }

  IconData getIcon(String type) {
    switch (type) {
      case "sucre":
        return Icons.local_drink;
      case "biere":
        return Icons.sports_bar;
      case "spiritueux":
        return Icons.wine_bar;
      default:
        return Icons.local_bar;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "sucre":
        return Colors.redAccent;
      case "biere":
        return Colors.amber;
      case "spiritueux":
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stock",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

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
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card résumé
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Stock: $sommeStock unités",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Totaux par type
                        ...sommeParType
                            .map(
                              (typeData) => Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      getIcon(typeData['type_boisson'] ?? ''),
                                      size: 16.sp,
                                      color: getColor(
                                        typeData['type_boisson'] ?? '',
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "${typeData['type_boisson'] ?? 'Non défini'}: ${typeData['quantite_totale'] ?? 0} unités",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Liste des stocks
                  Expanded(
                    child: ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        var stock = stocks[index];
                        var boisson = stock['boisson'];
                        if (boisson == null) return const SizedBox.shrink();

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                boisson['nom']
                                        ?.toString()
                                        .substring(0, 1)
                                        .toUpperCase() ??
                                    'B',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            title: Text(
                              boisson['nom'] ?? 'Nom inconnu',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Type: ${boisson['type_boisson']?['type'] ?? 'Non défini'}",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${stock['quantite_actuelle'] ?? 0}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  "unités",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showActions(stock),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 12,
        spaceBetweenChildren: 12,
        childMargin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        animatedIconTheme: const IconThemeData(size: 28.0),
        curve: Curves.bounceIn,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          // Bouton Ajouter une boisson
          SpeedDialChild(
            child: const Icon(Icons.local_bar, color: Colors.white),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Ajouter une boisson',
            labelStyle: const TextStyle(fontSize: 14.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AjouterBoissonPage(),
                ),
              );
            },
          ),
          // Bouton Ajouter un stock
          SpeedDialChild(
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Ajouter un stock',
            labelStyle: const TextStyle(fontSize: 14.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AjouterStockPage(),
                ),
              );
            },
          ),
          // Bouton Ajouter un type de boisson
          SpeedDialChild(
            child: const Icon(Icons.local_drink, color: Colors.white),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Ajouter un type de boisson',
            labelStyle: const TextStyle(fontSize: 14.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AjouterTypeBoissonPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
