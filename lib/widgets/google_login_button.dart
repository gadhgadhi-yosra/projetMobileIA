// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:supermarket_app_03072025/screens/chatbot_screen.dart';

// class GoogleLoginButton extends StatelessWidget {
//   const GoogleLoginButton({super.key});

//   Future<void> _signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       final user = userCredential.user;

//       if (user != null) {
//         // Vérifie si le user est déjà enregistré dans Firestore
//         final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
//         final doc = await docRef.get();

//         if (!doc.exists) {
//           await docRef.set({
//             'nom': googleUser.displayName?.split(' ').last ?? '',
//             'prenom': googleUser.displayName?.split(' ').first ?? '',
//             'email': user.email,
//             'photoUrl': user.photoURL,
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }

//         // Rediriger vers le Chatbot
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const ChatbotScreen()),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur Google Sign-In: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       icon: const Icon(Icons.login),
//       label: const Text("Se connecter avec Google"),
//       onPressed: () => _signInWithGoogle(context),
//       style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//     );
//   }
// }
