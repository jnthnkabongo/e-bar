import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  //static const String baseUrl = 'http://10.0.2.2:8000/api'; //Android
  //static const String baseUrl = 'http://127.0.0.1:8000/api'; //Windows

  static String get baseUrl {
    if (kIsWeb) {
      //Web
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      //Mobile Android
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isIOS) {
      //Mobile Iphone
      return 'http://127.0.0.1:8000/api';
    }
      // Default fallback for other platforms
      return 'http://localhost:8000/api';
  }

  static String? _token;
  // Configuration du token
  static void setToken(String token) {
    _token = token;
  }

  // Headers pour les requêtes authentifiées
  static Map<String, String> _getHeaders({bool requireAuth = true}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Connexion
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _getHeaders(requireAuth: false),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['acces_token'];

        // Sauvegarder le token localement
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Identifiants invalides',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token != null;
  }

  // Charger le token sauvegardé
  static Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    // Même si le backend est down, on nettoie localement
    await prefs.remove('auth_token');
    _token = null;

    return response.statusCode == 200;
  }

  // Profile utilisateur
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-profile'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur de chargement du profil'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement du dashboard',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des stocks
  static Future<Map<String, dynamic>> getStocks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeStock'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur de chargement des stocks'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter du stock
  static Future<Map<String, dynamic>> addStock(
    int boissonId,
    int quantite,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterStock'),
        headers: _getHeaders(),
        body: jsonEncode({'boisson_id': boissonId, 'quantite': quantite}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout du stock',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des boissons
  static Future<Map<String, dynamic>> getBoissons() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeBoisson'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement des boissons',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter une boisson
  static Future<Map<String, dynamic>> addBoisson(
    String nom,
    int typeBoissonId,
    double prix, {
    String? description,
    String? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterBoisson'),
        headers: _getHeaders(),
        body: jsonEncode({
          'nom': nom,
          'type_boisson_id': typeBoissonId,
          'prix': prix,
          'description': description,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout de la boisson',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter une vente
  static Future<Map<String, dynamic>> addVente(
    int boissonId,
    int quantite,
    double prix,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterVente'),
        headers: _getHeaders(),
        body: jsonEncode({
          'boisson_id': boissonId,
          'quantite': quantite,
          'prix': prix,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout de la vente',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des ventes
  static Future<Map<String, dynamic>> getVentes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeVente'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur de chargement des ventes'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Historiques
  static Future<Map<String, dynamic>> getHistoriques() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/historiques'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement des historiques',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter un utilisateur
  static Future<Map<String, dynamic>> addUtilisateur(
    String nom,
    String email,
    String password,
    int roleId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterUtilisateur'),
        headers: _getHeaders(),
        body: jsonEncode({
          'nom': nom,
          'email': email,
          'password': password,
          'role_id': roleId,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout de l\'utilisateur',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter un type de boisson
  static Future<Map<String, dynamic>> addTypeBoisson(String type) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterTypeBoisson'),
        headers: _getHeaders(),
        body: jsonEncode({'type': type}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout du type de boisson',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter un rôle
  static Future<Map<String, dynamic>> addRole(String nom) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterRole'),
        headers: _getHeaders(),
        body: jsonEncode({'nom': nom}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur lors de l\'ajout du rôle'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Ajouter une clôture
  static Future<Map<String, dynamic>> addCloture() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ajouterCloture'),
        headers: _getHeaders(),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Erreur lors de la clôture',
        };
      } else {
        return {
          'success': false,
          'message':
              'Erreur lors de l\'ajout de la clôture (Status: ${response.statusCode})',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des utilisateurs
  static Future<Map<String, dynamic>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeUser'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement des utilisateurs',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  //Liste des clotures
  static Future<Map<String, dynamic>> getClotures() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeCloture'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement des clotures',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des types de boissons
  static Future<Map<String, dynamic>> getTypeBoissons() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeTypeBoisson'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Erreur de chargement des types de boissons',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  // Liste des rôles
  static Future<Map<String, dynamic>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listeRole'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur de chargement des rôles'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }
}
