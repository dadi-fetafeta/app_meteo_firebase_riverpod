import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_api_meteo/UI/AuthPage.dart';
import 'package:test_api_meteo/services/AuthService.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _MasquePassword = true; // état initial

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
              border: Border.all(color: Colors.teal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                     Text("App MeT SignUp", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),),
                      SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                        filled: true, // fond rempli
                        fillColor: Colors.grey[200], // couleur de fond
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ), // coins arrondis comme une barre de recherche
                          borderSide: BorderSide.none, // pas de bordure visible
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _MasquePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _MasquePassword = !_MasquePassword;
                            });
                          },
                        ),
                        hintText: "Mot de passe",
                        filled: true, // fond rempli
                        fillColor: Colors.grey[200], // couleur de fond
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),

                          borderSide: BorderSide.none, // pas de bordure visible
                        ),
                      ),
                      obscureText: _MasquePassword,
                      onChanged: (value) {
                        setState(() {
                          _MasquePassword = value.isEmpty; // masque si vide
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      iconAlignment:
                          IconAlignment.start, //aligne l'icone au début
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // couleur de fond
                        foregroundColor:
                            Colors.white, // couleur du texte et de l'icône
                        minimumSize: Size(double.infinity, 50),
                      ),

                      icon: const Icon(Icons.check_circle),

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authService.register(
                            _emailController.text,
                            _passwordController.text,
                          );
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(),
                            ),
                          );
                        }
                      },

                      label: const Text("S'inscrire"),
                    ),

                    SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.teal),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Vous avez déjà un compte ? Se Connecter",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
