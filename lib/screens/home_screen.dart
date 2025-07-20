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