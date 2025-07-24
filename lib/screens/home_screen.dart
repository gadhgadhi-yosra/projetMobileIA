// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
// import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';
// import 'package:supermarket_app_03072025/widgets/product_card.dart';
// import '../providers/product_provider.dart';
// import '../widgets/custom_app_bar.dart';


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
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
//       bottomNavigationBar: const CustomCurvedNavigationBar(),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               colorScheme.primary.withOpacity(0.9),
//               colorScheme.secondary.withOpacity(0.7),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Image.asset(
//                   'assets/images/image.png',
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: Text(
//                   'Bienvenue chez Navin Supermarket',
//                   style: textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onPrimary,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 8.0,
//                         color: Colors.black.withOpacity(0.3),
//                         offset: const Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                   child: Text(
//                     'Découvrez une nouvelle façon de trouver ce dont vous avez besoin avec notre recherche rapide ou discutez avec notre assistant virtuel !',
//                     style: textTheme.bodyLarge?.copyWith(
//                       color: colorScheme.onPrimary.withOpacity(0.9),
//                       fontStyle: FontStyle.italic,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text('Recherche en cours de développement'),
//                         backgroundColor: colorScheme.primary,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(250, 60),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     backgroundColor: colorScheme.onPrimary,
//                     foregroundColor: colorScheme.primary,
//                     elevation: 5,
//                     shadowColor: Colors.black.withOpacity(0.3),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.search, size: 24),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Démarrer la recherche',
//                         style: textTheme.labelLarge?.copyWith(
//                           color: colorScheme.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text('Chatbot en cours de développement'),
//                         backgroundColor: colorScheme.secondary,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     minimumSize: const Size(250, 60),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     side: BorderSide(color: colorScheme.onPrimary, width: 2),
//                     backgroundColor: Colors.transparent,
//                     foregroundColor: colorScheme.onPrimary,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.chat_bubble_outline, size: 24),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Lancer le chatbot',
//                         style: textTheme.labelLarge?.copyWith(
//                           color: colorScheme.onPrimary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const CustomCurvedNavigationBar(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.9),
              colorScheme.secondary.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/image.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Bienvenue chez Navin Supermarket',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Découvrez une nouvelle façon de trouver ce dont vous avez besoin avec notre assistant virtuel !',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    // Redirige vers ChatbotScreen
                    Navigator.pushNamed(context, '/chatbot');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: colorScheme.onPrimary,
                    foregroundColor: colorScheme.primary,
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Lancer le chatbot',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Recherche en cours de développement'),
                        backgroundColor: colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Démarrer la recherche',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomCurvedNavigationBar(),
    );
  }
}