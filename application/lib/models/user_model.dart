class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'manager', 'server'
  final String? managerId; // Pour les serveurs, ID de leur gérant
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.managerId,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });

  // Permissions
  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager';
  bool get isServer => role == 'server';
  
  bool get canManageUsers => isAdmin || isManager;
  bool get canManageStock => isAdmin || isManager;
  bool get canManageExpenses => isAdmin || isManager;
  bool get canViewLogs => isAdmin;
  bool get canDoBackup => isAdmin || isManager;
  bool get canSell => isAdmin || isManager || isServer;
}
