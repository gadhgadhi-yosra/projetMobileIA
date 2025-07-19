import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:supermarket_app_03072025/screens/auth/otp_verification_screen.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _generatedOtp = '';

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
    super.dispose();
  }

  String _generateOtp() {
    var random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      try {
        _generatedOtp = _generateOtp();
        print('OTP généré pour $email : $_generatedOtp');

        var response = await http.post(
          Uri.parse('https://api.sendgrid.com/v3/mail/send'),
          headers: {
            'Authorization': 'Bearer YOUR_SENDGRID_API_KEY',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'personalizations': [{'to': [{'email': email}], 'subject': 'Votre code OTP'}],
            'from': {'email': 'your-verified-email@example.com'},
            'content': [{'type': 'text/plain', 'value': 'Votre code OTP est : $_generatedOtp\nValable 5 minutes.'}],
          }),
        );

        if (response.statusCode == 202) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(email: email, otp: _generatedOtp, userId: '',),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Un code OTP a été envoyé à $email. Vérifiez votre boîte mail !'),
              backgroundColor: Theme.of(context).colorScheme.success,
            ),
          );
        } else {
          print('Erreur SendGrid : ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'envoi de l\'OTP : ${response.body}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        print('Erreur Firebase : $e');
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Cet email n\'est pas inscrit. Veuillez vous inscrire d\'abord.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : ${e.message ?? e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        print('Erreur inattendue : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur inattendue : $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _sendResetLink() async {
    String email = _emailController.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Lien de réinitialisation envoyé à $email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un lien de réinitialisation a été envoyé à $email.'),
          backgroundColor: Theme.of(context).colorScheme.success,
        ),
      );
    } catch (e) {
      print('Erreur lors de l\'envoi du lien : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié', style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        elevation: 0,
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
                    height: 100,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Entrez votre email pour réinitialiser',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 30),
                SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre email',
                      prefixIcon: Icon(Icons.email, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text('Envoyer le code OTP', style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _sendResetLink,
                  child: Text('Envoyer un lien de réinitialisation', style: AppStyles.linkTextStyle),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Retour à la connexion', style: AppStyles.linkTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}