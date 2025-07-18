
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/product_provider.dart';
// import '../widgets/product_card.dart';
// import '../widgets/custom_app_bar.dart';
// // L'importation de app_colors n'est plus n\u00e9cessaire si on utilise Theme.of(context).colorScheme
// // import '../utils/app_colors.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         // Already on home
//         break;
//       case 1:
//         Navigator.of(context).pushNamed('/cart');
//         break;
//       case 2:
//         Navigator.of(context).pushNamed('/chatbot');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Navin Supermarket'),
//       body: productProvider.products.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.sentiment_dissatisfied, size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Aucun produit disponible pour le moment.',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0), // Padding l\u00e9g\u00e8rement augment\u00e9
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7, // Ajust\u00e9 pour mieux s'adapter aux cartes de produits
//                   crossAxisSpacing: 12, // Espacement augment\u00e9
//                   mainAxisSpacing: 12, // Espacement augment\u00e9
//                 ),
//                 itemCount: productProvider.products.length,
//                 itemBuilder: (context, index) {
//                   final product = productProvider.products[index];
//                   return ProductCard(
//                     product: product,
//                     onAddToCart: () {
//                       productProvider.addToCart(product);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${product.name} ajout\u00e9 au panier!'),
//                           backgroundColor: colorScheme.primary, // Utilise la couleur primaire du th\u00e8me
//                           behavior: SnackBarBehavior.floating, // Rend le SnackBar flottant
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           margin: const EdgeInsets.all(10),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Panier',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chatbot',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: colorScheme.primary, // Utilise la couleur primaire du th\u00e8me
//         unselectedItemColor: colorScheme.onSurface.withOpacity(0.6), // Couleur d\u00e9s\u00e9lectionn\u00e9e plus subtile
//         onTap: _onItemTapped,
//         backgroundColor: colorScheme.surface, // Utilise la couleur de surface du th\u00e8me pour le fond
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Texte s\u00e9lectionn\u00e9 en gras
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//         elevation: 8, // Ajoute une l\u00e9g\u00e8re ombre
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
// import '../providers/product_provider.dart';
// import '../widgets/product_card.dart';
// import '../widgets/custom_app_bar.dart';


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         Navigator.of(context).pushNamed('/cart');
//         break;
//       case 2:
//         Navigator.of(context).pushNamed('/chatbot');
//         break;
//       case 3:
//         Navigator.of(context).pushNamed('/employee-management');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Navin Supermarket'),
//       body: productProvider.products.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.sentiment_dissatisfied, size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Aucun produit disponible pour le moment.',
//                     style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: productProvider.products.length,
//                 itemBuilder: (context, index) {
//                   final product = productProvider.products[index];
//                   return ProductCard(
//                     product: product,
//                     onAddToCart: () {
//                       productProvider.addToCart(product);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${product.name} ajouté au panier!'),
//                           backgroundColor: colorScheme.success,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           margin: const EdgeInsets.all(10),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Panier',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chatbot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Employés',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: colorScheme.primary,
//         unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
//         onTap: _onItemTapped,
//         backgroundColor: colorScheme.surface,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//         elevation: 8,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
// import '../providers/product_provider.dart';
// import '../widgets/product_card.dart';
// import '../widgets/custom_app_bar.dart';


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         // Stay on HomeScreen
//         break;
//       case 1:
//         Navigator.of(context).pushNamed('/cart');
//         break;
//       case 2:
//         Navigator.of(context).pushNamed('/chatbot');
//         break;
//       case 3:
//         Navigator.of(context).pushNamed('/employee-management');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Navin Supermarket'),
//       body: productProvider.products.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.sentiment_dissatisfied, size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Aucun produit disponible pour le moment.',
//                     style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: productProvider.products.length,
//                 itemBuilder: (context, index) {
//                   final product = productProvider.products[index];
//                   return ProductCard(
//                     product: product,
//                     onAddToCart: () {
//                       productProvider.addToCart(product);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${product.name} ajouté au panier!'),
//                           backgroundColor: colorScheme.success,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           margin: const EdgeInsets.all(10),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Panier',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chatbot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Employés',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: colorScheme.primary,
//         unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
//         onTap: _onItemTapped,
//         backgroundColor: colorScheme.surface,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//         elevation: 8,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
// import 'package:supermarket_app_03072025/widgets/product_card.dart';
// import '../providers/product_provider.dart';

// import '../widgets/custom_app_bar.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) async {
//     if (index == _selectedIndex) return; // Pas besoin de recharger la même page

//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         // Reste sur Home
//         break;
//       case 1:
//         await Navigator.of(context).pushNamed('/cart');
//         // Quand on revient, remet l’index à 0 (Accueil)
//         setState(() {
//           _selectedIndex = 0;
//         });
//         break;
//       case 2:
//         await Navigator.of(context).pushNamed('/chatbot');
//         setState(() {
//           _selectedIndex = 0;
//         });
//         break;
//       case 3:
//         await Navigator.of(context).pushNamed('/employee-management');
//         setState(() {
//           _selectedIndex = 0;
//         });
//         break;
//       case 4:
//         await Navigator.of(context).pushNamed('/stock-management');
//         setState(() {
//           _selectedIndex = 0;
//         });
//         break;
//       case 5:
//         await Navigator.of(context).pushNamed('/profile');
//         setState(() {
//           _selectedIndex = 0;
//         });
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Navin Supermarket'),
//       body: productProvider.products.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.sentiment_dissatisfied,
//                       size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Aucun produit disponible pour le moment.',
//                     style: textTheme.titleMedium
//                         ?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: productProvider.products.length,
//                 itemBuilder: (context, index) {
//                   final product = productProvider.products[index];
//                   return ProductCard(
//                     product: product,
//                     onAddToCart: () {
//                       productProvider.addToCart(product);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${product.name} ajouté au panier!'),
//                           backgroundColor: colorScheme.success,
//                           behavior: SnackBarBehavior.floating,
//                           shape:
//                               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           margin: const EdgeInsets.all(10),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Panier',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chatbot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Employés',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory),
//             label: 'Stock',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: colorScheme.primary,
//         unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
//         onTap: _onItemTapped,
//         backgroundColor: colorScheme.surface,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//         elevation: 8,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';
import 'package:supermarket_app_03072025/widgets/product_card.dart';
import '../providers/product_provider.dart';
import '../widgets/custom_app_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Navin Supermarket'),
      body: productProvider.products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
                  const SizedBox(height: 20),
                  Text(
                    'Aucun produit disponible pour le moment.',
                    style: textTheme.titleMedium
                        ?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ProductCard(
                    product: product,
                    onAddToCart: () {
                      productProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} ajouté au panier!'),
                          backgroundColor: colorScheme.success,
                          behavior: SnackBarBehavior.floating,
                          shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.all(10),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      bottomNavigationBar: const CustomCurvedNavigationBar(),
    );
  }
}