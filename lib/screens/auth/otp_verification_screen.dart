
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otp; 

  const OtpVerificationScreen({super.key, required this.email, required this.otp});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  int _timerSeconds = 300; 
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _sendResetLink() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un nouveau lien de réinitialisation a été envoyé à ${widget.email}.'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification OTP'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Code OTP généré : ${widget.otp}', 
                  style: AppStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Entrez le code OTP reçu à ${widget.email}',
                  style: AppStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '*',
                      ),
                      maxLength: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez un chiffre';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  )),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Temps restant : ${(_timerSeconds ~/ 60).toString().padLeft(2, "0")}:${(_timerSeconds % 60).toString().padLeft(2, "0")}'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: _canResend ? _sendResetLink : null,
                      child: Text(_canResend ? 'Renvoyer le lien' : 'Renvoyer dans ${(_timerSeconds ~/ 60).toString().padLeft(2, "0")}:${(_timerSeconds % 60).toString().padLeft(2, "0")}'),
                      style: TextButton.styleFrom(
                        foregroundColor: _canResend ? null : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Retour', style: AppStyles.linkTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}