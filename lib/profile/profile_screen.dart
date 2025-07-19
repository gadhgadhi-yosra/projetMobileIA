// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:supermarket_app_03072025/screens/auth/login_screen.dart';
// import 'package:supermarket_app_03072025/utils/app_styles.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _numeroController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
//   final RegExp passwordRegex = RegExp(r'^.{6,}$');
//   final RegExp nameRegex = RegExp(r'^[a-zA-Z ]{2,}$');
//   final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
//   final RegExp adresseRegex = RegExp(r'^.{5,}$');

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//   }

//   Future<void> _loadUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         final data = doc.data()!;
//         setState(() {
//           _nameController.text = data['name'] ?? '';
//           _emailController.text = data['email'] ?? '';
//           _numeroController.text = data['numero'] ?? '';
//           _adresseController.text = data['adresse'] ?? '';
//         });
//       }
//     }
//   }

//   void _updateProfile() {
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'numero': _numeroController.text.trim(),
//           'adresse': _adresseController.text.trim(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         }).then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profil mis à jour avec succès !')),
//           );
//           setState(() {}); // Rafraîchit l'interface
//         }).catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erreur lors de la mise à jour : $error')),
//           );
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/image.png',
//                   height: 120,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _nameController.text.isNotEmpty ? _nameController.text : 'Nom d’utilisateur',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _emailController.text.isNotEmpty ? _emailController.text : 'Email@exemple.com',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 40),

//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nom',
//                     hintText: 'Entrez votre nom',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre nom';
//                     }
//                     if (!nameRegex.hasMatch(value)) {
//                       return 'Nom invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'Entrez votre email',
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre email';
//                     }
//                     if (!emailRegex.hasMatch(value)) {
//                       return 'Veuillez entrer un email valide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _numeroController,
//                   keyboardType: TextInputType.phone,
//                   decoration: const InputDecoration(
//                     labelText: 'Numéro de téléphone',
//                     hintText: 'Entrez votre numéro de téléphone',
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre numéro de téléphone';
//                     }
//                     if (!phoneRegex.hasMatch(value)) {
//                       return 'Numéro de téléphone invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _adresseController,
//                   decoration: const InputDecoration(
//                     labelText: 'Adresse',
//                     hintText: 'Entrez votre adresse',
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre adresse';
//                     }
//                     if (!adresseRegex.hasMatch(value)) {
//                       return 'Adresse invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Mot de passe',
//                     hintText: 'Entrez votre mot de passe',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   validator: (value) {
//                     if (value != null && value.isNotEmpty && !passwordRegex.hasMatch(value)) {
//                       return 'Le mot de passe doit contenir au moins 6 caractères';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Confirmer le mot de passe',
//                     hintText: 'Confirmez votre mot de passe',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez confirmer votre mot de passe';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Les mots de passe ne correspondent pas';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),

//                 ElevatedButton(
//                   onPressed: _updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Confirmer'),
//                 ),
//                 const SizedBox(height: 20),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Se déconnecter ?',
//                       style: AppStyles.bodyText2,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => const LoginScreen()),
//                           (Route<dynamic> route) => false,
//                         );
//                       },
//                       child: Text('Déconnexion', style: AppStyles.linkTextStyle),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:supermarket_app_03072025/screens/auth/login_screen.dart';
// import 'package:supermarket_app_03072025/utils/app_styles.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final TextEditingController _numeroController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//   }

//   Future<void> _loadUserProfile() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       try {
//         final doc = await _firestore.collection('users').doc(user.uid).get();
//         if (doc.exists) {
//           final data = doc.data()!;
//           setState(() {
//             _nameController.text = data['name'] ?? '';
//             _prenomController.text = data['prenom'] ?? '';
//             _emailController.text = data['email'] ?? user.email ?? '';
//             _numeroController.text = data['numero'] ?? '';
//             _adresseController.text = data['adresse'] ?? '';
//           });
//         } else {
//           // Créer un document par défaut si inexistant
//           await _firestore.collection('users').doc(user.uid).set({
//             'name': '',
//             'prenom': '',
//             'email': user.email ?? '',
//             'numero': '',
//             'adresse': '',
//             'createdAt': FieldValue.serverTimestamp(),
//             'updatedAt': FieldValue.serverTimestamp(),
//           });
//           setState(() {
//             _emailController.text = user.email ?? '';
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erreur lors du chargement du profil : $e')),
//           );
//         }
//       }
//     }
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       final user = _auth.currentUser;
//       if (user != null) {
//         if (!user.emailVerified) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Veuillez vérifier votre email avant de modifier votre profil.')),
//             );
//           }
//           return;
//         }
//         try {
//           // Mise à jour des informations dans Firestore
//           await _firestore.collection('users').doc(user.uid).update({
//             'name': _nameController.text.trim(),
//             'prenom': _prenomController.text.trim(),
//             'email': _emailController.text.trim(),
//             'numero': _numeroController.text.trim(),
//             'adresse': _adresseController.text.trim(),
//             'updatedAt': FieldValue.serverTimestamp(),
//           });

//           // Mise à jour du mot de passe si fourni
//           if (_passwordController.text.isNotEmpty &&
//               _passwordController.text == _confirmPasswordController.text) {
//             await user.updatePassword(_passwordController.text.trim());
//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Mot de passe mis à jour avec succès !')),
//               );
//             }
//           }

//           // Mise à jour de l'email si modifié
//           if (_emailController.text.trim() != user.email) {
//             await user.verifyBeforeUpdateEmail(_emailController.text.trim());
//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Vérifiez votre nouvel email pour confirmer la modification.')),
//               );
//             }
//           }

//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Profil mis à jour avec succès !')),
//             );
//           }
//         } catch (e) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
//             );
//           }
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _nameController.dispose();
//     _prenomController.dispose();
//     _numeroController.dispose();
//     _adresseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[200],
//                   child: Icon(Icons.person, size: 60, color: Colors.grey[800]),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _nameController.text.isNotEmpty
//                       ? '${_nameController.text} ${_prenomController.text}'
//                       : 'Nom d\'utilisateur',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _emailController.text.isNotEmpty
//                       ? _emailController.text
//                       : 'Email@exemple.com',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 40),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nom',
//                     hintText: 'Entrez votre nom',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre nom';
//                     }
//                     if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
//                       return 'Nom invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _prenomController,
//                   decoration: const InputDecoration(
//                     labelText: 'Prénom',
//                     hintText: 'Entrez votre prénom',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre prénom';
//                     }
//                     if (!RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(value)) {
//                       return 'Prénom invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'Entrez votre email',
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre email';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return 'Veuillez entrer un email valide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _numeroController,
//                   keyboardType: TextInputType.phone,
//                   decoration: const InputDecoration(
//                     labelText: 'Numéro de téléphone',
//                     hintText: 'Entrez votre numéro',
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _adresseController,
//                   decoration: const InputDecoration(
//                     labelText: 'Adresse',
//                     hintText: 'Entrez votre adresse',
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Nouveau mot de passe',
//                     hintText: 'Laissez vide pour ne pas changer',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Confirmer le mot de passe',
//                     hintText: 'Confirmez le nouveau mot de passe',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   validator: (value) {
//                     if (_passwordController.text.isNotEmpty &&
//                         value != _passwordController.text) {
//                       return 'Les mots de passe ne correspondent pas';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Mettre à jour'),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     _auth.signOut();
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       (Route<dynamic> route) => false,
//                     );
//                   },
//                   child: Text('Se déconnecter', style: AppStyles.linkTextStyle),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:supermarket_app_03072025/screens/auth/login_screen.dart';
// import 'package:supermarket_app_03072025/utils/app_styles.dart';
// import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final TextEditingController _numeroController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
//   final RegExp nameRegex = RegExp(r'^[a-zA-Z ]{2,}$');
//   final RegExp phoneRegex = RegExp(r'^\+216\s\d{2}\s\d{2}\s\d{2}\s\d{2}$');
//   final RegExp adresseRegex = RegExp(r'^.{5,}$');

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//     _numeroController.text = '+216 12 34 56 78'; // Valeur par défaut avec format tunisien
//     _adresseController.text = 'Avenue feuillé d\'érable Lac 2'; // Adresse par défaut
//   }

//   Future<void> _loadUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         final data = doc.data()!;
//         setState(() {
//           _nameController.text = data['nom'] ?? '';
//           _prenomController.text = data['prenom'] ?? '';
//           _emailController.text = data['email'] ?? '';
//           _numeroController.text = data['numero'] ?? '+216 12 34 56 78';
//           _adresseController.text = data['adresse'] ?? 'Avenue feuillé d\'érable Lac 2';
//         });
//       }
//     }
//   }

//   void _updateProfile() {
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'nom': _nameController.text.trim(),
//           'prenom': _prenomController.text.trim(),
//           'email': _emailController.text.trim(),
//           'numero': _numeroController.text.trim(),
//           'adresse': _adresseController.text.trim(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         }).then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profil mis à jour avec succès !')),
//           );
//           setState(() {});
//         }).catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erreur lors de la mise à jour : $error')),
//           );
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/image.png',
//                   height: 120,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _prenomController.text.isNotEmpty && _nameController.text.isNotEmpty
//                       ? '${_prenomController.text} ${_nameController.text}'
//                       : 'Nom d\'utilisateur',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _emailController.text.isNotEmpty ? _emailController.text : 'Adresse Email',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 40),

//                 TextFormField(
//                   controller: _prenomController,
//                   decoration: const InputDecoration(
//                     labelText: 'Prénom',
//                     hintText: 'Entrez votre prénom',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre prénom';
//                     }
//                     if (!nameRegex.hasMatch(value)) {
//                       return 'Prénom invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nom',
//                     hintText: 'Entrez votre nom',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre nom';
//                     }
//                     if (!nameRegex.hasMatch(value)) {
//                       return 'Nom invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Adresse Email',
//                     hintText: 'Entrez votre email',
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre email';
//                     }
//                     if (!emailRegex.hasMatch(value)) {
//                       return 'Veuillez entrer un email valide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _numeroController,
//                   keyboardType: TextInputType.phone,
//                   decoration: const InputDecoration(
//                     labelText: 'Numéro de téléphone',
//                     hintText: 'Entrez +216 suivi de 8 chiffres (ex: +216 12 34 56 78)',
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre numéro de téléphone';
//                     }
//                     if (!phoneRegex.hasMatch(value)) {
//                       return 'Numéro invalide. Utilisez +216 suivi de 8 chiffres avec espaces (ex: +216 12 34 56 78)';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: _adresseController,
//                   decoration: const InputDecoration(
//                     labelText: 'Adresse',
//                     hintText: 'Entrez votre adresse',
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre adresse';
//                     }
//                     if (!adresseRegex.hasMatch(value)) {
//                       return 'Adresse invalide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),

//                 ElevatedButton(
//                   onPressed: _updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Confirmer'),
//                 ),
//                 const SizedBox(height: 20),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Se déconnecter ?',
//                       style: AppStyles.bodyText2,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => const LoginScreen()),
//                           (Route<dynamic> route) => false,
//                         );
//                       },
//                       child: Text('Déconnexion', style: AppStyles.linkTextStyle),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//        bottomNavigationBar: const CustomCurvedNavigationBar(), // Ajout de la barre de navigation
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_app_03072025/screens/auth/login_screen.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';
import 'profile_service.dart'; // Import du service backend

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
  final RegExp nameRegex = RegExp(r'^[a-zA-Z ]{2,}$');
  final RegExp phoneRegex = RegExp(r'^\+216\s\d{2}\s\d{2}\s\d{2}\s\d{2}$');
  final RegExp adresseRegex = RegExp(r'^.{5,}$');

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _numeroController.text = '+216 12 34 56 78';
    _adresseController.text = 'Avenue feuillé d\'érable Lac 2';
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await _profileService.getProfile();
      if (data != null) {
        setState(() {
          _nameController.text = data['nom'] ?? '';
          _prenomController.text = data['prenom'] ?? '';
          _emailController.text = data['email'] ?? user.email ?? '';
          _numeroController.text = data['numero'] ?? '+216 12 34 56 78';
          _adresseController.text = data['adresse'] ?? 'Avenue feuillé d\'érable Lac 2';
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _profileService.updateProfile(
          nom: _nameController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          numero: _numeroController.text.trim(),
          adresse: _adresseController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.person, size: 60, color: colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_prenomController.text} ${_nameController.text}'.isNotEmpty
                          ? '${_prenomController.text} ${_nameController.text}'
                          : 'Utilisateur',
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text.isNotEmpty ? _emailController.text : 'email@example.com',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_prenomController, 'Prénom', Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Nom', Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', Icons.email, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField(_numeroController, 'Numéro', Icons.phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField(_adresseController, 'Adresse', Icons.location_on),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: colorScheme.primary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text('Mettre à jour', style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
                    ),
                    const SizedBox(height: 20),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Se déconnecter ?',
                      style: AppStyles.bodyText2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Déconnexion', style: AppStyles.linkTextStyle),
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const CustomCurvedNavigationBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label est requis';
        if (label == 'Email' && !emailRegex.hasMatch(value)) return 'Email invalide';
        if ((label == 'Prénom' || label == 'Nom') && !nameRegex.hasMatch(value)) return '$label invalide';
        if (label == 'Numéro' && !phoneRegex.hasMatch(value)) return 'Numéro invalide (ex: +216 12 34 56 78)';
        if (label == 'Adresse' && !adresseRegex.hasMatch(value)) return 'Adresse trop courte';
        return null;
      },
    );
  }
}