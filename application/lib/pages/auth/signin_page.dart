import 'package:application/pages/auth/signup_page.dart';
import 'package:application/pages/gerant/main_page.dart';
import 'package:application/pages/navigation/main_page.dart';
import 'package:application/pages/vendeur/main_page.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (result['success']) {
        final user = result['data']['user'];
        final roleId = user['role_id'] as int;
        final roleName = result['data']['role_name'];

        // Debug pour voir ce qu'on reçoit exactement
        print('User : $user');
        print('Role ID: $roleId');
        print('Type de role: $roleName');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Connexion réussie")));

        // Convertir en nombre pour être sûr
        //final roleId = role is int ? role : int.tryParse(role.toString()) ?? 0;
        //print('Role ID converti: $roleId');

        if (roleId == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        } else if (roleId == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPageGerant()),
          );
        } else if (roleId == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPageVendeur()),
          );
        } else {
          // Pour tout autre rôle non prévu
          print(
            'Rôle non reconnu: $roleId - Redirection vers MainPage par défaut',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erreur de connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.local_bar, size: 100, color: Colors.blue),
                const SizedBox(height: 24),

                const Text(
                  "e-Bar Manager",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Text(
                  "Connexion à votre espace",
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                ),

                const SizedBox(height: 90),

                // Formulaire
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email obligatoire";
                            }
                            if (!value.contains("@")) {
                              return "Email invalide";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return "Minimum 4 caractères";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Bouton
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Se connecter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔗 LIEN CRÉATION DE COMPTE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pas encore de compte ? "),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  "En vous connectant, vous acceptez nos conditions "
                  "d'utilisation et notre politique de confidentialité.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 16),

                const Text(
                  "© 2026 e-Bar Manager",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
