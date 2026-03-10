import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<dynamic> historiques = [];
  Map<String, List<dynamic>> groupedHistoriques = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
    _loadHistoriques();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('fr_FR', null);
  }

  Future<void> _loadHistoriques() async {
    try {
      final result = await ApiService.getHistoriques();
      if (result['success']) {
        setState(() {
          historiques = result['data']['historiques'] ?? [];
          _groupHistoriquesByDate();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _groupHistoriquesByDate() {
    groupedHistoriques.clear();

    // Trier les historiques par date (du plus récent au plus ancien)
    historiques.sort((a, b) {
      DateTime dateA = DateTime.parse(a['created_at']);
      DateTime dateB = DateTime.parse(b['created_at']);
      return dateB.compareTo(dateA);
    });

    // Grouper par date
    for (var item in historiques) {
      DateTime createdAt = DateTime.parse(item['created_at']);
      String dateKey = DateFormat('yyyy-MM-dd').format(createdAt);

      if (!groupedHistoriques.containsKey(dateKey)) {
        groupedHistoriques[dateKey] = [];
      }
      groupedHistoriques[dateKey]!.add(item);
    }
  }

  String _formatDateHeader(String dateKey) {
    DateTime date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final saleDate = DateTime(date.year, date.month, date.day);

    if (saleDate == today) {
      return "Aujourd'hui - ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  Color getOperationColor(String operation) {
    if (operation.toLowerCase().contains("vente")) return Colors.green;
    if (operation.toLowerCase().contains("ajout")) return Colors.blue;
    if (operation.toLowerCase().contains("suppression")) return Colors.red;
    if (operation.toLowerCase().contains("clôture")) return Colors.orange;
    return Colors.grey;
  }

  IconData getOperationIcon(String operation) {
    if (operation.toLowerCase().contains("vente")) return Icons.shopping_cart;
    if (operation.toLowerCase().contains("ajout")) return Icons.add_box;
    if (operation.toLowerCase().contains("suppression")) return Icons.delete;
    if (operation.toLowerCase().contains("clôture")) return Icons.check_circle;
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historique",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedHistoriques.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64.sp, color: Colors.grey.shade400),
                  SizedBox(height: 16.h),
                  Text(
                    'Aucun historique disponible',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: groupedHistoriques.keys.length,
              itemBuilder: (context, index) {
                String dateKey = groupedHistoriques.keys.elementAt(index);
                List<dynamic> dayHistoriques = groupedHistoriques[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 8.h),
                      child: Text(
                        _formatDateHeader(dateKey),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ...dayHistoriques.map((item) {
                      final operation = item['type_action'] ?? 'Non défini';
                      final color = getOperationColor(operation);
                      final icon = getOperationIcon(operation);
                      final user = item['user'] ?? {};
                      final userName = user['nom'] ?? 'Utilisateur inconnu';

                      // Formatage de l'heure
                      DateTime createdAt = DateTime.parse(item['created_at']);
                      String formattedTime = DateFormat(
                        'HH:mm',
                      ).format(createdAt);

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Icon(icon, color: Colors.white, size: 20.sp),
                          ),
                          title: Text(
                            operation,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Par : $userName",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item['details'] ?? 'Aucun détail',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 6.h),
                  ],
                );
              },
            ),
    );
  }
}
