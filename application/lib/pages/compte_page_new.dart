import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ComptePage extends StatefulWidget {
  const ComptePage({super.key});

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  List<dynamic> ventes = [];
  Set<int> selectedVentes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVentes();
  }

  Future<void> _loadVentes() async {
    try {
      final result = await ApiService.getVentes();
      if (result['success']) {
        var data = result['data'];
        if (data is Map && data.containsKey('data')) {
          var ventesParDate = data['data']['ventes_par_date'] ?? {};
          List<dynamic> allVentes = [];
          ventesParDate.forEach((date, ventes) {
            if (ventes is List) {
              allVentes.addAll(ventes);
            }
          });

          setState(() {
            ventes = allVentes;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading ventes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double _getSelectedTotal() {
    double total = 0.0;
    for (var vente in ventes) {
      if (selectedVentes.contains(vente['id'])) {
        total += double.tryParse(vente['prix'].toString()) ?? 0.0;
      }
    }
    return total;
  }

  void _showInvoicePreview() {
    final selectedSales = ventes
        .where((vente) => selectedVentes.contains(vente['id']))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prévisualisation Facture',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoRow(
                      'Date:',
                      DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    ),
                    _buildInfoRow(
                      'N° Facture:',
                      'FAC-${DateTime.now().millisecondsSinceEpoch}',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Total ventes:',
                      '${selectedVentes.length}',
                      Colors.blue,
                    ),
                    _buildSummaryRow(
                      'Montant total:',
                      '${_getSelectedTotal().toStringAsFixed(2)} FC',
                      Colors.green,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: selectedSales.length,
                  itemBuilder: (context, index) {
                    final vente = selectedSales[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vente['boisson']?['nom'] ??
                                      'Boisson inconnue',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${vente['quantite'] ?? 0} pcs',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(double.tryParse(vente['prix'].toString()) ?? 0.0).toStringAsFixed(2)} FC',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _exporterPDF();
                      },
                      icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text('Exporter PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _partagerFacture();
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text('Partager'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exporterPDF() async {
    try {
      final selectedSales = ventes
          .where((vente) => selectedVentes.contains(vente['id']))
          .toList();
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'FACTURE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Numéro: FAC-${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      pw.Text(
                        'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  data: [
                    ['Produit', 'Quantité', 'Prix'],
                    ...selectedSales
                        .map(
                          (vente) => [
                            vente['boisson']?['nom'] ?? 'Boisson inconnue',
                            '${vente['quantite'] ?? 0}',
                            '${(double.tryParse(vente['prix'].toString()) ?? 0.0).toStringAsFixed(2)} FC',
                          ],
                        )
                        ,
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total: ${_getSelectedTotal().toStringAsFixed(2)} FC',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green700,
                  ),
                ),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'Facture_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Facture sauvegardée: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );

      await _sharePDF(file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sharePDF(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Facture E-Bar',
        text: 'Voici votre facture générée depuis E-Bar',
      );
    } catch (e) {
      print('Erreur partage: $e');
    }
  }

  Future<void> _partagerFacture() async {
    await _exporterPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Factures',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadVentes,
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadVentes,
              child: Column(
                children: [
                  // En-tête avec actions rapides
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  selectedVentes.clear();
                                  for (var vente in ventes) {
                                    selectedVentes.add(vente['id']);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.select_all,
                                  color: Colors.white,
                                ),
                                label: Text('Tout sélectionner'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  selectedVentes.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.deselect),
                                label: Text('Tout désélectionner'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.blue),
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${selectedVentes.length} vente(s) sélectionnée(s)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              Text(
                                'Total: ${_getSelectedTotal().toStringAsFixed(2)} FC',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Liste des ventes
                  Expanded(
                    child: ventes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 64.sp,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Aucune vente disponible',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Les ventes apparaîtront ici une fois effectuées',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: ventes.length,
                            itemBuilder: (context, index) {
                              final vente = ventes[index];
                              final isSelected = selectedVentes.contains(
                                vente['id'],
                              );

                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue.shade300
                                        : Colors.grey.shade200,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedVentes.add(vente['id']);
                                      } else {
                                        selectedVentes.remove(vente['id']);
                                      }
                                    });
                                  },
                                  title: Text(
                                    vente['boisson']?['nom'] ??
                                        'Boisson inconnue',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              '${vente['quantite'] ?? 0} pcs',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy HH:mm',
                                            ).format(
                                              DateTime.parse(
                                                vente['created_at'],
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  secondary: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(double.tryParse(vente['prix'].toString()) ?? 0.0).toStringAsFixed(2)} FC',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      GestureDetector(
                                        onTap: () {
                                          selectedVentes.clear();
                                          selectedVentes.add(vente['id']);
                                          _showInvoicePreview();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Text(
                                            'Facturer',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  activeColor: Colors.blue,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Bouton d'action flottant
                  if (selectedVentes.isNotEmpty)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _showInvoicePreview(),
                        icon: Icon(Icons.receipt_long, color: Colors.white),
                        label: Text(
                          'Générer Facture (${selectedVentes.length})',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 26.h),
                          minimumSize: Size(double.infinity, 20.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
