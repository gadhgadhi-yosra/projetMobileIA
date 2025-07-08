
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/product.dart';
// // L'importation de app_colors n'est plus n\u00e9cessaire si on utilise Theme.of(context).colorScheme
// // import '../utils/app_colors.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onAddToCart;

//   const ProductCard({
//     Key? key,
//     required this.product,
//     required this.onAddToCart,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac');
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;

//     return Card(
//       // S'appuie sur le CardTheme d\u00e9fini dans AppTheme pour l'\u00e9l\u00e9vation et la forme
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).pushNamed(
//             '/product-detail',
//             arguments: product,
//           );
//         },
//         borderRadius: BorderRadius.circular(12), // Applique le borderRadius \u00e0 InkWell pour un effet de tap coh\u00e9rent
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   product.imageUrl,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                             : null,
//                         color: colorScheme.secondary, // Utilise la couleur d'accent secondaire pour le chargement
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: colorScheme.surface, // Utilise la couleur de surface du th\u00e8me pour le fond d'erreur
//                       child: Icon(Icons.broken_image, color: colorScheme.onSurface.withOpacity(0.6)), // Utilise onSurface pour la couleur de l'ic\u00f4ne
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0), // Padding l\u00e9g\u00e8rement augment\u00e9 pour un meilleur espacement
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: textTheme.titleMedium?.copyWith(
//                       color: colorScheme.onSurface, // Assure que la couleur du texte provient du th\u00e8me
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.category,
//                     style: textTheme.bodySmall?.copyWith(
//                       color: colorScheme.onSurface.withOpacity(0.7), // Texte de cat\u00e9gorie l\u00e9g\u00e8rement estomp\u00e9
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         currencyFormatter.format(product.price),
//                         style: textTheme.titleLarge?.copyWith(
//                           color: colorScheme.primary, // Utilise la couleur d'accent primaire pour le prix
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 40, // Largeur fixe pour le bouton
//                         height: 40, // Hauteur fixe pour le bouton
//                         child: ElevatedButton(
//                           onPressed: onAddToCart,
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(40, 40), // Assure un bouton carr\u00e9
//                             padding: EdgeInsets.zero, // Supprime le padding par d\u00e9faut
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8), // Correspond au rayon existant
//                             ),
//                             // backgroundColor et foregroundColor sont d\u00e9j\u00e0 d\u00e9finis dans ElevatedButtonThemeData de AppTheme
//                           ),
//                           child: const Icon(
//                             Icons.add_shopping_cart,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/product-detail',
            arguments: product,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: colorScheme.secondary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.surface,
                      child: Icon(Icons.broken_image, color: colorScheme.onSurface.withOpacity(0.6)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormatter.format(product.price),
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: onAddToCart,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(40, 40),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}