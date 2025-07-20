
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String nom,
    required String prenom,
    required String email,
    required String numero,
    required String adresse,
    File? profileImage, 
    String? profileImagePath,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      String? imagePath = profileImagePath; 

      if (profileImage != null) {
        try {

          final appDir = await getApplicationDocumentsDirectory();
          final fileName = 'profile_image_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final savedImage = await profileImage.copy('${appDir.path}/$fileName');
          imagePath = savedImage.path; 
        } catch (e) {
          throw Exception('Erreur lors de la sauvegarde de l\'image : $e');
        }
      }


      await _firestore.collection('users').doc(user.uid).set({
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'email': email.trim(),
        'numero': numero.trim(),
        'adresse': adresse.trim(),
        'profileImagePath': imagePath,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

     
      if (email.trim() != user.email) {
        await user.updateEmail(email.trim());
      }
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  Future<void> deleteProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
    
      final profileData = await getProfile();
      if (profileData != null && profileData['profileImagePath'] != null) {
        try {
          final file = File(profileData['profileImagePath']);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('Erreur lors de la suppression de l\'image : $e');
        }
      }

    
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    }
  }
}