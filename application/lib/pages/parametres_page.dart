import 'package:application/pages/auth/signin_page.dart';
import 'package:application/pages/historiques_page.dart';
import 'package:application/pages/users_page.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  String _language = "Français";
  Map<String, dynamic>? userData;
  Map<String, dynamic>? dashboardData;
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

      setState(() {
        userData = profileResult['success']
            ? profileResult['data']['user']
            : null;
        dashboardData = dashboardResult['success']
            ? dashboardResult['data']
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

  void _backupData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Backup effectué avec succès")),
    );
  }

  void _restoreData() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Restauration terminée")));
  }

  void _logout() {
    ApiService.logout();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
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
                children: [
                  // 👤 Carte profil utilisateur
                  Container(
                    width: double.infinity,
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
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Infos utilisateur
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bonjour, ${userData?['name'] ?? 'Utilisateur'} 👋",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rôle : ${userData?['role_name'] ?? 'Non défini'}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Bouton édition profil
                        Icon(Icons.edit, color: Colors.blue),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SettingsSection(
                    title: "Utilisateurs",
                    children: [
                      SettingsActionTile(
                        icon: Icons.people,
                        title: "Gérer les utilisateurs",
                        //subtitle: "Ajouter, modifier, supprimer des utilisateurs",
                        onTap: () {
                          // Navigation vers la page des utilisateurs
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UsersPage(),
                            ),
                          );
                        },
                      ),
                      SettingsActionTile(
                        icon: Icons.history_outlined,
                        title: "Historique (Log)",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoriquePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // 🔐 Sécurité
                  SettingsSection(
                    title: "Sécurité",
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.fingerprint,
                        title: "Empreinte digitale",
                        subtitle: "Se connecter avec la biométrie",
                        value: _biometricEnabled,
                        onChanged: (value) {
                          setState(() => _biometricEnabled = value);
                        },
                      ),
                      SettingsActionTile(
                        icon: Icons.lock,
                        title: "Changer le mot de passe",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 💾 Sauvegarde
                  SettingsSection(
                    title: "Sauvegarde & données",
                    children: [
                      SettingsActionTile(
                        icon: Icons.backup,
                        title: "Sauvegarder les données",
                        onTap: _backupData,
                      ),
                      SettingsActionTile(
                        icon: Icons.restore,
                        title: "Restaurer une sauvegarde",
                        onTap: _restoreData,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🌍 Préférences
                  SettingsSection(
                    title: "Préférences",
                    children: [
                      SettingsDropdownTile(
                        icon: Icons.language,
                        title: "Langue",
                        value: _language,
                        items: const ["Français", "English"],
                        onChanged: (value) {
                          setState(() => _language = value!);
                        },
                      ),
                      SettingsSwitchTile(
                        icon: Icons.notifications,
                        title: "Notifications",
                        subtitle: "Activer les alertes",
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Se déconnecter",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    "© 2026 e-Bar Manager",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class SettingsDropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SettingsDropdownTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
