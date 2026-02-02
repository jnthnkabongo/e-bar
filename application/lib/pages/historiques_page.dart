import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<dynamic> historiques = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoriques();
  }

  Future<void> _loadHistoriques() async {
    try {
      final result = await ApiService.getHistoriques();
      if (result['success']) {
        setState(() {
          historiques = result['data']['historiques'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView.builder(
                itemCount: historiques.length,
                itemBuilder: (context, index) {
                  final item = historiques[index];
                  final operation = item['type_action'] ?? 'Non défini';
                  final color = getOperationColor(operation);
                  final icon = getOperationIcon(operation);
                  final user = item['user'] ?? {};
                  final userName = user['nom'] ?? 'Utilisateur inconnu';

                  // Formatage de la date
                  DateTime createdAt = DateTime.parse(item['created_at']);
                  String formattedDate = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(createdAt);

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          userName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
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
                          Text("Par : $userName"),
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(icon, color: color, size: 20.sp),
                          SizedBox(height: 4.h),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
