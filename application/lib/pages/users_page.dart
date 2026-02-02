import 'package:application/pages/ajouter_user.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final result = await ApiService.getUsers();

      if (result['success']) {
        setState(() {
          users = result['data']['users'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          users = [];
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ??
                    'Erreur lors du chargement des utilisateurs',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        users = [];
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Map<String, int> getUserCountByRole() {
    Map<String, int> counts = {};
    for (var user in users) {
      String roleName = _getRoleName(user['role_id']);
      counts[roleName] = (counts[roleName] ?? 0) + 1;
    }
    return counts;
  }

  String _getRoleName(int roleId) {
    // Utiliser les données de l'API si disponibles, sinon fallback
    for (var user in users) {
      if (user['role_id'] == roleId && user['role'] != null) {
        return user['role']['nom'] ?? _getRoleNameFallback(roleId);
      }
    }
    return _getRoleNameFallback(roleId);
  }

  String _getRoleNameFallback(int roleId) {
    switch (roleId) {
      case 1:
        return "Administrateur";
      case 2:
        return "Gérant";
      case 3:
        return "Serveur";
      default:
        return "Non défini";
    }
  }

  void _editUser(int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Modifier ${users[index]['nom']}")));
    // TODO: ouvrir formulaire modification
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text(
          "Voulez-vous vraiment supprimer ${users[index]['nom']} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Utilisateur supprimé avec succès")),
              );
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  Future<void> _addUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterUserPage()),
    );

    // Si l'ajout a réussi, recharger la liste
    if (result == true) {
      _loadUsers();
    }
  }

  Future<void> _refreshUsers() async {
    await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> counts = getUserCountByRole();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestion des utilisateurs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Card résumé utilisateurs par rôle
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
                            "Nombre d'utilisateurs par rôle",
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
                            children: counts.entries.map((entry) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  "${entry.key} : ${entry.value}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Liste utilisateurs
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    users[index]['is_active'] == true
                                    ? Colors.green
                                    : Colors.grey,
                                child: Text(
                                  users[index]['nom'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              title: Text(
                                users[index]['nom'],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_getRoleName(users[index]['role_id'])),
                                  Text(
                                    users[index]['email'],
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _editUser(index),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteUser(index),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
