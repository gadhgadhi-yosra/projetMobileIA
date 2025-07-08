// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:supermarket_app_03072025/utils/app_styles.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _nameController.dispose();
//     _prenomController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       print('Validation réussie');
//       if (_passwordController.text == _confirmPasswordController.text) {
//         try {
//           print('Tentative d\'inscription avec $_emailController.text');
//           UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//             email: _emailController.text.trim(),
//             password: _passwordController.text.trim(),
//           );

//           await userCredential.user!.sendEmailVerification();
//           print('Email de vérification envoyé à ${userCredential.user!.email}');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Inscription réussie ! Vérifiez votre email pour activer votre compte.')),
//             );
//             Navigator.pushReplacementNamed(context, '/login');
//           }
//         } on FirebaseAuthException catch (e) {
//           print('Erreur Firebase : $e');
//           String message = 'Erreur inconnue';
//           switch (e.code) {
//             case 'email-already-in-use':
//               message = 'Cet email est déjà utilisé.';
//               break;
//             case 'weak-password':
//               message = 'Le mot de passe est trop faible (minimum 6 caractères).';
//               break;
//             case 'invalid-email':
//               message = 'L\'email est invalide.';
//               break;
//             default:
//               message = 'Erreur : ${e.message}';
//           }
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(message)),
//             );
//           }
//         } catch (e) {
//           print('Erreur inattendue : $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Erreur inattendue : $e')),
//             );
//           }
//         }
//       } else {
//         print('Mots de passe différents');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
//           );
//         }
//       }
//     } else {
//       print('Validation échouée');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inscription'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Image.asset(
//                     'assets/images/image.png',
//                     height: 120,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Nom',
//                       hintText: 'Entrez votre nom',
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre nom';
//                       }
//                       if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
//                         return 'Nom invalide';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: TextFormField(
//                     controller: _prenomController,
//                     decoration: const InputDecoration(
//                       labelText: 'Prénom',
//                       hintText: 'Entrez votre prénom',
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre prénom';
//                       }
//                       if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
//                         return 'Prénom invalide';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       hintText: 'Entrez votre email',
//                       prefixIcon: Icon(Icons.email),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Veuillez entrer un email valide';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Mot de passe',
//                       hintText: 'Créez un mot de passe',
//                       prefixIcon: Icon(Icons.lock),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez créer un mot de passe';
//                       }
//                       if (value.length < 6) {
//                         return 'Le mot de passe doit contenir au moins 6 caractères';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Confirmer le mot de passe',
//                       hintText: 'Confirmez votre mot de passe',
//                       prefixIcon: Icon(Icons.lock),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez confirmer votre mot de passe';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Les mots de passe ne correspondent pas';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: ElevatedButton(
//                     onPressed: _register,
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text('S\'inscrire'),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Déjà un compte ?',
//                       style: AppStyles.bodyText2,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/login');
//                       },
//                       child: Text('Se connecter', style: AppStyles.linkTextStyle),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Enregistrement des informations supplémentaires dans Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'name': _nameController.text.trim(),
            'prenom': _prenomController.text.trim(),
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'numero': '',
            'adresse': '',
          });

          await userCredential.user!.sendEmailVerification();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription réussie ! Vérifiez votre email pour activer votre compte.')),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        } on FirebaseAuthException catch (e) {
          String message = 'Erreur inconnue';
          switch (e.code) {
            case 'email-already-in-use':
              message = 'Cet email est déjà utilisé.';
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                // Redirection vers la page de connexion
                await Future.delayed(const Duration(seconds: 2)); // Attendre que l'utilisateur voie le message
                Navigator.pushReplacementNamed(context, '/login');
              }
              break;
            case 'weak-password':
              message = 'Le mot de passe est trop faible (minimum 6 caractères).';
              break;
            case 'invalid-email':
              message = 'L\'email est invalide.';
              break;
            default:
              message = 'Erreur : ${e.message}';
          }
          if (mounted && e.code != 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur inattendue : $e')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/images/image.png',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 40),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      hintText: 'Entrez votre nom',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
                        return 'Nom invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      hintText: 'Entrez votre prénom',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre prénom';
                      }
                      if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
                        return 'Prénom invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Créez un mot de passe',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez créer un mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      hintText: 'Confirmez votre mot de passe',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer votre mot de passe';
                      }
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('S\'inscrire'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ?',
                      style: AppStyles.bodyText2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Se connecter', style: AppStyles.linkTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}