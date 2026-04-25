import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_api_meteo/UI/MeteoScreen.dart';
import 'package:test_api_meteo/UI/SignUp.dart';
import 'package:test_api_meteo/UI/favoriteScreen.dart';
import 'package:test_api_meteo/providers/firebase_providers.dart';
import 'package:test_api_meteo/services/AuthService.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.teal[50],

      // appBar: AppBar(
      //   title: const Text("App MeT", style: TextStyle(color: Colors.white),),
      //   backgroundColor: Colors.teal,
      //   actions: [

      //   ],
      // ),
      body: authState.when(
        // gère les différents états de l'authentification
        data: (user) {
          // si l'utilisateur est connecté, affiche ses infos et un bouton de déconnexion
          if (user != null) {
            //
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 40,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                      ),
                      Text("Connecté : ${user.email}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => ref.read(authServiceProvider).logout(),
                            child: const Text("Se déconnecter"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.bookmark,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Meteoscreen()
                    ),
                  // child: Container(
                  //   width: double.infinity,
                  //   height: 300,
                  //   decoration: BoxDecoration(
                  //     color: Colors.transparent,
                  //     // borderRadius: BorderRadius.circular(16),
                  //     // boxShadow: [
                  //     //   BoxShadow(
                  //     //     color: Colors.teal.withOpacity(0.3),
                  //     //     blurRadius: 10,
                  //     //     offset: Offset(0, 4),
                  //     //   ),
                  //     // ],
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       "Bienvenue dans l'application météo !\n\nIci, vous pouvez consulter les prévisions météorologiques de votre région et de vos villes préférées. Profitez d'une interface simple et intuitive pour rester informé des conditions météorologiques en temps réel.",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(fontSize: 16, color: Colors.teal[700]),
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            );
          } else {
            return const AuthForm();
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }
}

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({super.key});

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _MasquePassword = true; // état initial

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(30),
                  //   bottomRight: Radius.circular(30),
                  // ),
                  image: DecorationImage(
                    image: AssetImage("assets/images/meteo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "App MeT LogIn",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 20),

                        TextFormField(
                          textCapitalization : TextCapitalization.none, // pas de majuscules automatiques
                          keyboardType: TextInputType.emailAddress, // clavier adapté pour les emails
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email",
                            filled: true, // fond rempli
                            fillColor: Colors.grey[200], // couleur de fond
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,//
                              horizontal: 16.0,// espace intérieur pour une meilleure lisibilité
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ), // coins arrondis comme une barre de recherche
                              borderSide:BorderSide.none, // pas de bordure visible
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',// expression régulière simple pour valider un email
                            ).hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          //obscuringCharacter: '•',
                        
                          //keyboardType: TextInputType.visiblePassword, // clavier adapté pour les mots de passe
                          obscureText: _MasquePassword,
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

                              borderSide:
                                  BorderSide.none, // pas de bordure visible
                            ),
                          ),
                      
                          // onChanged: (value) {
                          //   setState(() {
                          //     _MasquePassword = value.isEmpty; // masque si vide
                          //   });
                          // },

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

                          icon: const Icon(Icons.login),

                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authService.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },

                          label: const Text("Se connecter"),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          child: const Text("Pas de compte ? S'inscrire"),
                        ),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.tealAccent[700],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                    title: Text("Google Login"),
                                    content: Text("Coming Soon !"),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/google.png",
                                width: 24,
                              ),
                              label: const Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.tealAccent[700],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                    title: Text("Facebook Login"),
                                    content: Text("Coming Soon !"),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.facebook,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Facebook",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
