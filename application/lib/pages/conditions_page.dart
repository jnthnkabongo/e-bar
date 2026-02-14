import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConditionsPage extends StatefulWidget {
  const ConditionsPage({super.key});

  @override
  State<ConditionsPage> createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<ConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conditions Générales d\'Utilisation',
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
            _buildSectionTitle('1. Objet des CGU'),
            _buildSectionContent(
              'Les présentes Conditions Générales d\'Utilisation (CGU) régissent l\'utilisation de l\'application mobile e-Bar, '
              'une solution de gestion pour bars et restaurants. En utilisant l\'application, vous acceptez sans réserve '
              'les présentes conditions.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('2. Acceptation des conditions'),
            _buildSectionContent(
              'L\'utilisation de l\'application e-Bar implique l\'acceptation pleine et entière des présentes CGU. '
              'Si vous n\'acceptez pas ces conditions, vous ne devez pas utiliser cette application.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('3. Description du service'),
            _buildSectionContent(
              'e-Bar est une application mobile destinée à faciliter la gestion quotidienne des établissements '
              'de type bar et restaurant. Les fonctionnalités principales incluent :\n\n'
              '• Gestion des ventes et des transactions\n'
              '• Suivi des stocks et des inventaires\n'
              '• Génération de factures et de rapports\n'
              '• Interface intuitive pour les serveurs et gérants\n'
              '• Sauvegarde sécurisée des données',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('4. Responsabilités de l\'utilisateur'),
            _buildSectionContent(
              'En tant qu\'utilisateur de e-Bar, vous vous engagez à :\n\n'
              '• Fournir des informations exactes et à jour lors de l\'inscription\n'
              '• Maintenir la confidentialité de vos identifiants de connexion\n'
              '• Utiliser l\'application conformément à sa finalité\n'
              '• Ne pas tenter de pirater, décompiler ou modifier l\'application\n'
              '• Respecter la législation en vigueur concernant la gestion d\'établissements',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('5. Propriété intellectuelle'),
            _buildSectionContent(
              'L\'application e-Bar et son contenu (logiciel, interface, textes, graphiques, logos, etc.) '
              'sont la propriété exclusive de leurs créateurs et sont protégés par les lois sur la '
              'propriété intellectuelle. Toute reproduction, distribution ou modification non autorisée '
              'est strictement interdite.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('6. Protection des données personnelles'),
            _buildSectionContent(
              'Nous nous engageons à protéger vos données personnelles conformément au RGPD. '
              'Les données collectées sont utilisées exclusivement pour le fonctionnement de l\'application '
              'et ne sont jamais partagées avec des tiers sans votre consentement explicite. '
              'Vous disposez d\'un droit d\'accès, de modification et de suppression de vos données.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('7. Limitation de responsabilité'),
            _buildSectionContent(
              'e-Bar est fournie "en l\'état" sans garantie d\'aucune sorte. Notre responsabilité ne peut '
              'être engagée pour les dommages directs ou indirects résultant de l\'utilisation de l\'application, '
              'y compris la perte de données ou de revenus. Il vous appartient de sauvegarder régulièrement '
              'vos données importantes.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('8. Disponibilité du service'),
            _buildSectionContent(
              'Nous nous efforçons de maintenir l\'application accessible en permanence, mais des interruptions '
              'peuvent survenir pour maintenance, mises à jour ou en cas de force majeure. Nous ne garantissons '
              'pas une disponibilité continue et ininterrompue du service.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('9. Évolution des CGU'),
            _buildSectionContent(
              'Nous nous réservons le droit de modifier les présentes CGU à tout moment. '
              'Les modifications entreront en vigueur dès leur publication sur l\'application. '
              'Il vous appartient de consulter régulièrement la dernière version des CGU.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('10. Loi applicable et juridiction'),
            _buildSectionContent(
              'Les présentes CGU sont régies par le droit en vigueur dans votre pays. '
              'En cas de litige, les tribunaux compétents seront ceux de votre lieu de résidence.',
            ),

            SizedBox(height: 24.h),

            _buildSectionTitle('11. Contact'),
            _buildSectionContent(
              'Pour toute question concernant les présentes CGU ou l\'application e-Bar, '
              'vous pouvez nous contacter à :\n\n'
              'Email : jnthnkabongo@gmail.com\n'
              'Téléphone : +243 974133780',
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
                    'En utilisant e-Bar, vous confirmez avoir lu, compris et accepté ces conditions.',
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
