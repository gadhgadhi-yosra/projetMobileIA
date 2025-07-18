// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:supermarket_app_03072025/providers/navigation_provider.dart';


// class CustomCurvedNavigationBar extends StatelessWidget {
//   const CustomCurvedNavigationBar({Key? key}) : super(key: key);

//   void _onItemTapped(BuildContext context, int index) {
//     final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
//     if (navigationProvider.selectedIndex == index) return; // Pas besoin de recharger la même page

//     navigationProvider.setIndex(index);

//     // Navigation directe sans animation en remplaçant la page actuelle
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/home');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/cart');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/chatbot');
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, '/employee-management');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, '/stock-management');
//         break;
//       case 5:
//         Navigator.pushReplacementNamed(context, '/profile');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final navigationProvider = Provider.of<NavigationProvider>(context);

//     return CurvedNavigationBar(
//       backgroundColor: colorScheme.background, // Fond de la page
//       color: colorScheme.primary.withOpacity(0.9), // Fond de la barre
//       buttonBackgroundColor: Colors.yellow[600], // Jaune pour l'icône sélectionnée
//       height: 60,
//       animationDuration: const Duration(milliseconds: 300),
//       animationCurve: Curves.easeInOut,
//       index: navigationProvider.selectedIndex,
//       items: <Widget>[
//         Icon(Icons.home, size: 30, color: navigationProvider.selectedIndex == 0 ? Colors.black : colorScheme.onPrimary),
//         Icon(Icons.shopping_cart, size: 30, color: navigationProvider.selectedIndex == 1 ? Colors.black : colorScheme.onPrimary),
//         Icon(Icons.chat, size: 30, color: navigationProvider.selectedIndex == 2 ? Colors.black : colorScheme.onPrimary),
//         Icon(Icons.people, size: 30, color: navigationProvider.selectedIndex == 3 ? Colors.black : colorScheme.onPrimary),
//         Icon(Icons.inventory, size: 30, color: navigationProvider.selectedIndex == 4 ? Colors.black : colorScheme.onPrimary),
//         Icon(Icons.person, size: 30, color: navigationProvider.selectedIndex == 5 ? Colors.black : colorScheme.onPrimary),
//       ],
//       onTap: (index) => _onItemTapped(context, index),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_app_03072025/profile/profile_screen.dart';
import 'package:supermarket_app_03072025/providers/navigation_provider.dart';
import 'package:supermarket_app_03072025/screens/cart_screen.dart';
import 'package:supermarket_app_03072025/screens/chatbot_screen.dart';
import 'package:supermarket_app_03072025/screens/employees/employee_management_screen.dart';
import 'package:supermarket_app_03072025/screens/home_screen.dart';
import 'package:supermarket_app_03072025/stock/stock_management_screen.dart';


class CustomCurvedNavigationBar extends StatelessWidget {
  const CustomCurvedNavigationBar({Key? key}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
    if (navigationProvider.selectedIndex == index) return; 

    navigationProvider.setIndex(index);


    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
              break;
            case 1:
              page = const CartScreen();
              break;
            case 2:
              page = const ChatbotScreen();
              break;
            case 3:
              page = const EmployeeManagementScreen();
              break;
            case 4:
              page = const StockManagementScreen();
              break;
            case 5:
              page = const ProfileScreen();
              break;
            default:
              page = const HomeScreen();
          }
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.2); 
          const end = Offset.zero; 
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return CurvedNavigationBar(
      backgroundColor: colorScheme.background, 
      color: colorScheme.primary.withOpacity(0.9),
      buttonBackgroundColor: Colors.yellow[600], 
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      index: navigationProvider.selectedIndex,
      items: <Widget>[
        Image.asset('assets/images/accueil.png', width: 30, height: 30, color: navigationProvider.selectedIndex == 0 ? Colors.white : colorScheme.onPrimary),
        Image.asset('assets/images/sac-de-courses.png', width: 30, height: 30, color: navigationProvider.selectedIndex == 1 ? Colors.white : colorScheme.onPrimary),
        Image.asset('assets/images/bot-de-discussion.png', width: 30, height: 30, color: navigationProvider.selectedIndex == 2 ? Colors.white : colorScheme.onPrimary),
        Image.asset('assets/images/emploi.png', width: 30, height: 30, color: navigationProvider.selectedIndex == 3 ? Colors.white : colorScheme.onPrimary),
        Image.asset('assets/images/entrepot.png', width: 30, height: 30, color: navigationProvider.selectedIndex == 4 ? Colors.white : colorScheme.onPrimary),
        Image.asset('assets/images/utilisateur.png', width: 29, height: 29, color: navigationProvider.selectedIndex == 5 ? Colors.white : colorScheme.onPrimary),
      ],
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}