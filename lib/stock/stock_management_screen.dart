import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';


class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Smartphone X', 'price': 899.99, 'stock': 15, 'status': 'stable'},
    {'name': 'Laptop Pro 15', 'price': 1499.99, 'stock': 8, 'status': 'increase'},
    {'name': 'Smartwatch Z', 'price': 249.99, 'stock': 30, 'status': 'decrease'},
    {'name': 'Casque Audio BT', 'price': 129.99, 'stock': 22, 'status': 'stable'},
    {'name': 'Tablette Tactile', 'price': 399.99, 'stock': 12, 'status': 'increase'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Gestion du Stock'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomeScreen
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gestion du Stock',
              style: AppStyles.headline2.copyWith(color: colorScheme.onBackground),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                Color statusColor;
                IconData statusIcon;

                switch (product['status']) {
                  case 'increase':
                    statusColor = colorScheme.error;
                    statusIcon = Icons.arrow_upward;
                    break;
                  case 'decrease':
                    statusColor = colorScheme.success;
                    statusIcon = Icons.arrow_downward;
                    break;
                  default:
                    statusColor = AppColors.grey;
                    statusIcon = Icons.horizontal_rule;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: AppStyles.headline3.copyWith(color: colorScheme.onSurface),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Prix: ${product['price']} €',
                                style: AppStyles.bodyText1.copyWith(color: colorScheme.onSurface),
                              ),
                              Text(
                                'Stock: ${product['stock']}',
                                style: AppStyles.bodyText1.copyWith(color: colorScheme.onSurface),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 30),
                            Text(
                              product['status'].toUpperCase(),
                              style: AppStyles.bodyText2.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.edit, color: colorScheme.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Modifier ${product['name']}'),
                                backgroundColor: colorScheme.success,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ajouter un nouveau produit'),
              backgroundColor: colorScheme.success,
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}