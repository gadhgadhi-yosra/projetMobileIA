
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:supermarket_app_03072025/providers/navigation_provider.dart';
import 'package:supermarket_app_03072025/providers/product_provider.dart';
import 'package:supermarket_app_03072025/screens/auth/forgot_password_screen.dart';
import 'package:supermarket_app_03072025/screens/auth/login_screen.dart';
import 'package:supermarket_app_03072025/screens/auth/profile_screen.dart';
import 'package:supermarket_app_03072025/screens/auth/register_screen.dart' ;
import 'package:supermarket_app_03072025/screens/chatbot_screen.dart';
import 'package:supermarket_app_03072025/screens/employees/employee_management_screen.dart';
import 'package:supermarket_app_03072025/screens/home_screen.dart';
import 'package:supermarket_app_03072025/screens/product_detail_screen.dart';
import 'package:supermarket_app_03072025/screens/splash_screens/splash_screen.dart';
import 'package:supermarket_app_03072025/screens/stock/stock_management_screen.dart';

import 'package:supermarket_app_03072025/utils/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 Initialiser Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()), 
      ],
      child: MaterialApp(
        title: 'Navin Supermarket',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/chatbot': (context) => const ChatbotScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/employee-management': (context) => const EmployeeManagementScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/stock-management': (context) => const StockManagementScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}