
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:supermarket_app_03072025/screens/auth/otp_verification_screen.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
import 'package:supermarket_app_03072025/widgets/custom_elevated_button.dart';
import 'package:supermarket_app_03072025/widgets/custom_text_button.dart';
import 'package:supermarket_app_03072025/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _generatedOtp = '';

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
            'personalizations': [
              {'to': [{'email': email}], 'subject': 'Votre code OTP'}
            ],
            'from': {'email': 'your-verified-email@example.com'},
            'content': [
              {
                'type': 'text/plain',
                'value': 'Votre code OTP est : $_generatedOtp\nValable 5 minutes.'
              }
            ],
          }),
        );

        if (response.statusCode == 202) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(email: email, otp: _generatedOtp),
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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image.png',
                  height: 100,
                ),
                const SizedBox(height: 40),
                Text(
                  'Entrez votre email pour réinitialiser',
                  style: AppStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
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
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: _sendOtp,
                  text: 'Envoyer le code OTP',
                ),
                const SizedBox(height: 10),
                CustomTextButton(
                  onPressed: _sendResetLink,
                  text: 'Envoyer un lien de réinitialisation',
                ),
                const SizedBox(height: 20),
                CustomTextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  text: 'Retour à la connexion',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}