import 'package:application/pages/compte_page_new.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CloturePage extends StatefulWidget {
  const CloturePage({super.key});

  @override
  State<CloturePage> createState() => _CloturePageState();
}

class _CloturePageState extends State<CloturePage> {
  Map<String, dynamic> ventesParDate = {};
  bool isLoading = true;
  double chiffreVendu = 0.0;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadVentes();
    _loadData();
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

  Future<void> _loadVentes() async {
    try {
      final result = await ApiService.getVentes();
      print('DEBUG: Result from API: $result'); // Debug
      if (result['success']) {
        setState(() {
          // Accéder aux données selon la structure réelle
          var data = result['data'];
          if (data is Map && data.containsKey('data')) {
            ventesParDate = data['data']['ventes_par_date'] ?? {};
          } else {
            ventesParDate = data['ventes_par_date'] ?? {};
          }
          print('DEBUG: ventesParDate: $ventesParDate'); // Debug
          _calculateChiffreVendu();
          isLoading = false;
        });
      } else {
        setState(() {
          ventesParDate = {};
          isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG: Error loading ventes: $e'); // Debug
      setState(() {
        isLoading = false;
      });
    }
  }

  void _calculateChiffreVendu() {
    double total = 0.0;
    ventesParDate.forEach((date, ventes) {
      if (ventes is List) {
        for (var vente in ventes) {
          total += double.tryParse(vente['prix'].toString()) ?? 0.0;
        }
      }
    });
    chiffreVendu = total;
  }

  // Formater la date pour l'affichage
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final saleDate = DateTime(date.year, date.month, date.day);

      if (saleDate == today) {
        return "Aujourd'hui - ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } else {
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      }
    } catch (e) {
      return dateString;
    }
  }

  Map<String, int> getTotals() {
    Map<String, int> totals = {};
    ventesParDate.forEach((date, ventes) {
      if (ventes is List) {
        for (var vente in ventes) {
          // Pour l'instant, nous n'avons pas le type dans l'API, nous utiliserons un placeholder
          String type = "Non défini";
          totals[type] = (totals[type] ?? 0) + (vente['quantite'] as int);
        }
      }
    });
    return totals;
  }

  Map<String, List<Map<String, dynamic>>> groupByDate() {
    return ventesParDate.map(
      (key, value) => MapEntry(
        key,
        List<Map<String, dynamic>>.from(value is List ? value : []),
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type) {
      case "Soft":
        return Colors.redAccent;
      case "Bière":
        return Colors.green;
      case "Spiritueux":
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case "Soft":
        return Icons.local_drink;
      case "Bière":
        return Icons.sports_bar;
      case "Spiritueux":
        return Icons.wine_bar;
      default:
        return Icons.local_bar;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> totals = getTotals();
    Map<String, List<Map<String, dynamic>>> ventesParDate = groupByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ventes",
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
                  // Card résumé chiffre et quantités
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chiffre vendu : ${chiffreVendu.toStringAsFixed(2)} FC",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 8.h,
                          children: totals.entries.map((entry) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: getTypeColor(entry.key).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    getTypeIcon(entry.key),
                                    size: 18.sp,
                                    color: getTypeColor(entry.key),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "${entry.key} : ${entry.value} Bouteilles",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Liste des ventes par date
                  Expanded(
                    child: ListView(
                      children: ventesParDate.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(entry.key),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ...entry.value.map((vente) {
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 6.h),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      "${vente['quantite'] ?? 0}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          vente['boisson']?['nom'] ??
                                              'Boisson inconnue',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "${vente['quantite'] ?? 0} pcs",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Prix: ${double.tryParse(vente['prix'].toString())?.toStringAsFixed(2) ?? '0.00'} FC | ",
                                            ),
                                            TextSpan(
                                              text:
                                                  "Total: ${((vente['quantite'] ?? 0) * double.tryParse(vente['prix'].toString()) ?? 0.0).toStringAsFixed(2)} FC",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Afficher le nom du vendeur si disponible
                                      if (vente['user'] != null &&
                                          vente['user']['nom'] != null)
                                        Text(
                                          "Vendeur: ${vente['user']['nom']}",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey.shade500,
                                          ),
                                        )
                                      else
                                        Text(
                                          "Vendeur: Non spécifié",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey.shade400,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 12.h),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComptePage()),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
