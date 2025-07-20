import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket_app_03072025/services/profile_service.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';
import 'package:supermarket_app_03072025/widgets/custom_text_field.dart';
import 'package:supermarket_app_03072025/widgets/custom_elevated_button.dart';
import 'package:supermarket_app_03072025/widgets/custom_text_button.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _profileImagePath;
  bool _isLoading = true;

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
  final RegExp nameRegex = RegExp(r'^[a-zA-Z ]{2,}$');
  final RegExp phoneRegex = RegExp(r'^\+216\s\d{2}\s\d{2}\s\d{2}\s\d{2}$');
  final RegExp adresseRegex = RegExp(r'^.{5,}$');

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _numeroController.text = '+216 12 34 56 78';
    _adresseController.text = "Avenue feuillé d'érable Lac 2";
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
          _adresseController.text = data['adresse'] ?? "Avenue feuillé d'érable Lac 2";
          _profileImagePath = data['profileImagePath'];
          if (_profileImagePath != null && !File(_profileImagePath!).existsSync()) {
            _profileImagePath = null;
          }
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File tempImage = File(pickedFile.path);
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_image_${FirebaseAuth.instance.currentUser?.uid ?? 'temp'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedImage = await tempImage.copy('${appDir.path}/$fileName');
      setState(() {
        _selectedImage = savedImage;
        _profileImagePath = savedImage.path;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _profileService.updateProfile(
        nom: _nameController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        numero: _numeroController.text.trim(),
        adresse: _adresseController.text.trim(),
        profileImage: _selectedImage,
        profileImagePath: _profileImagePath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil mis à jour avec succès !')));
        await _loadUserProfile();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      setState(() => _isLoading = false);
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : _profileImagePath != null && File(_profileImagePath!).existsSync()
                                    ? FileImage(File(_profileImagePath!)) as ImageProvider
                                    : null,
                            backgroundColor: colorScheme.primary.withOpacity(0.1),
                            child: _selectedImage == null && (_profileImagePath == null || !File(_profileImagePath!).existsSync())
                                ? Icon(Icons.person, size: 60, color: colorScheme.primary)
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: colorScheme.surface, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, size: 18, color: colorScheme.onPrimary),
                          ),
                        ],
                      ),
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
                    CustomTextField(
                      controller: _prenomController,
                      label: 'Prénom',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Prénom requis';
                        if (!nameRegex.hasMatch(value)) return 'Prénom invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nom',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Nom requis';
                        if (!nameRegex.hasMatch(value)) return 'Nom invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email requis';
                        if (!emailRegex.hasMatch(value)) return 'Email invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _numeroController,
                      label: 'Numéro',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Numéro requis';
                        if (!phoneRegex.hasMatch(value)) return 'Numéro invalide (ex: +216 12 34 56 78)';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _adresseController,
                      label: 'Adresse',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Adresse requise';
                        if (!adresseRegex.hasMatch(value)) return 'Adresse trop courte';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      onPressed: _updateProfile,
                      text: 'Mettre à jour',
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Se déconnecter ?', style: AppStyles.bodyText2),
                        CustomTextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          text: 'Déconnexion',
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
}