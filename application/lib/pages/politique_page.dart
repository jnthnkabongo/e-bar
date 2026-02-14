import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolitiquePage extends StatefulWidget {
  const PolitiquePage({super.key});

  @override
  State<PolitiquePage> createState() => _PolitiquePageState();
}

class _PolitiquePageState extends State<PolitiquePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Politique de Confidentialité',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Introduction'),
            _buildSectionContent(
              'Chez e-Bar, nous nous engageons à protéger votre vie privée et à sécuriser vos données personnelles. '
              'Cette politique de confidentialité explique quelles informations nous collectons, comment nous les '
              'utilisons et les droits dont vous disposez concernant vos données.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('2. Données collectées'),
            _buildSectionContent(
              'Nous collectons les types de données suivants :\n\n'
              'Informations de compte :\n'
              '• Nom, prénom et adresse email\n'
              '• Numéro de téléphone\n'
              '• Mot de passe (crypté)\n'
              '• Informations sur votre établissement\n\n'
              'Données d\'utilisation :\n'
              '• Historique des ventes et transactions\n'
              '• Données d\'inventaire et de stocks\n'
              '• Rapports et statistiques générés\n'
              '• Préférences et paramètres de l\'application\n\n'
              'Données techniques :\n'
              '• Adresse IP et type d\'appareil\n'
              '• Version de l\'application\n'
              '• Journaux d\'utilisation et diagnostics',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('3. Utilisation des données'),
            _buildSectionContent(
              'Vos données sont utilisées pour :\n\n'
              '• Fournir et maintenir le service e-Bar\n'
              '• Traiter vos transactions et générer des factures\n'
              '• Améliorer nos fonctionnalités et services\n'
              '• Vous assister en cas de problème technique\n'
              '• Vous informer des mises à jour importantes\n'
              '• Respecter nos obligations légales et réglementaires',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('4. Partage des données'),
            _buildSectionContent(
              'Nous ne vendons, ne louons ni ne partageons vos données personnelles avec des tiers, '
              'sauf dans les cas suivants :\n\n'
              '• Avec votre consentement explicite\n'
              '• Pour respecter la loi : si nous y sommes légalement obligés\n'
              '• Prestataires de services : partenaires techniques nécessaires au fonctionnement\n'
              '• Transfert d\'activité : en cas de fusion, acquisition ou vente\n\n'
              'Tous nos partenaires sont tenus de respecter la confidentialité de vos données.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('5. Sécurité des données'),
            _buildSectionContent(
              'Nous mettons en œuvre des mesures de sécurité robustes :\n\n'
              '• Cryptage : toutes vos données sont cryptées lors du transfert et du stockage\n'
              '• Contrôle d\'accès : seul le personnel autorisé peut accéder à vos données\n'
              '• Sauvegardes régulières : pour prévenir la perte de données\n'
              '• Mises à jour de sécurité : nous maintenons nos systèmes à jour\n'
              '• Audit de sécurité : vérifications régulières de nos protocoles',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('6. Conservation des données'),
            _buildSectionContent(
              'Nous conservons vos données uniquement aussi longtemps que nécessaire :\n\n'
              '• Données de compte : tant que votre compte est actif\n'
              '• Données transactionnelles : 7 ans pour des raisons comptables et fiscales\n'
              '• Données techniques : 1 an maximum pour l\'analyse et l\'amélioration\n\n'
              'À la clôture de votre compte, nous supprimons ou anonymisons vos données personnelles.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('7. Vos droits (RGPD)'),
            _buildSectionContent(
              'Conformément au RGPD, vous disposez des droits suivants :\n\n'
              '• Droit d\'accès : savoir quelles données nous détenons sur vous\n'
              '• Droit de rectification : corriger vos informations inexactes\n'
              '• Droit de suppression : demander la suppression de vos données\n'
              '• Droit de limitation : limiter l\'utilisation de vos données\n'
              '• Droit de portabilité : recevoir vos données dans un format lisible\n'
              '• Droit d\'opposition : vous opposer à certains traitements\n\n'
              'Pour exercer ces droits, contactez-nous à jnthnkabongo@gmail.com',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('8. Cookies et technologies similaires'),
            _buildSectionContent(
              'Notre application utilise des technologies similaires aux cookies pour :\n\n'
              '• Mémoriser vos préférences et paramètres\n'
              '• Analyser l\'utilisation de l\'application\n'
              '• Améliorer les performances et la sécurité\n\n'
              'Vous pouvez contrôler ces technologies dans les paramètres de votre appareil.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('9. Modifications de la politique'),
            _buildSectionContent(
              'Nous pouvons mettre à jour cette politique de confidentialité pour :\n\n'
              '• Refléter des changements dans nos pratiques\n'
              '• Nous conformer à de nouvelles réglementations\n'
              '• Améliorer la transparence de nos pratiques\n\n'
              'Toute modification sera notifiée dans l\'application et prendra effet immédiatement.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('10. Contact'),
            _buildSectionContent(
              'Pour toute question concernant cette politique de confidentialité ou vos données :\n\n'
              'Email : jnthnkabongo@gmail.com\n'
              'Téléphone : +243 974133780\n\n'
              'Nous nous engageons à répondre à votre demande dans les plus brefs délais.',
            ),

            SizedBox(height: 32.h),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Text(
                    'Dernière mise à jour : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Votre confiance est notre priorité. Nous nous engageons à protéger vos données avec le plus grand soin.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        content,
        style: TextStyle(fontSize: 14.sp, height: 1.5, color: Colors.black87),
      ),
    );
  }
}
