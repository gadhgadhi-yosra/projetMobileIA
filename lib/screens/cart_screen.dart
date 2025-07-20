

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';
import '../providers/product_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'DT');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Panier'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: productProvider.cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
                        const SizedBox(height: 20),
                        Text(
                          'Votre panier est vide.',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                     
                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                          },
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text('Commencer vos achats'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: productProvider.cart.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.cart[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: colorScheme.secondary,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: colorScheme.onSurface.withOpacity(0.2),
                                    child: Icon(Icons.broken_image,
                                        color: colorScheme.onSurface.withOpacity(0.6)),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              currencyFormatter.format(product.price),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever, color: colorScheme.error),
                              onPressed: () {
                                productProvider.removeFromCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} retiré du panier.'),
                                    backgroundColor: colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.all(10),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(productProvider.cartTotal),
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: productProvider.cart.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Procédure de paiement simulée.'),
                              backgroundColor: colorScheme.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.all(10),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Procéder au paiement',
                    style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
       bottomNavigationBar: const CustomCurvedNavigationBar(), 
    );
  }
}
