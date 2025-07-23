
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supermarket_app_03072025/models/stockProduct.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';


class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _searchController = TextEditingController();
  String _selectedStatus = 'stable';
  String _searchQuery = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _showProductDialog({StockProduct? product, String? id}) async {
    final isEditing = product != null && id != null;
    if (isEditing) {
      _nameController.text = product!.name;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _selectedStatus = product.status;
    } else {
      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      _selectedStatus = 'stable';
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              final colorScheme = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 24,
                  right: 24,
                  top: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEditing ? 'Modifier le produit' : 'Ajouter un produit',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: colorScheme.onSurface.withOpacity(0.6)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nom du produit',
                            hintText: 'Ex: Smartphone X',
                            prefixIcon: Icon(Icons.shopping_bag_outlined, color: colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                            errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le nom du produit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Prix (DT)',
                            hintText: 'Ex: 99.99',
                            prefixIcon: Icon(Icons.monetization_on_outlined, color: colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                            errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le prix';
                            }
                            final parsedPrice = double.tryParse(value.trim());
                            if (parsedPrice == null) {
                              return 'Veuillez entrer un nombre valide';
                            }
                            if (parsedPrice < 0) {
                              return 'Le prix ne peut pas être négatif';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantité en stock',
                            hintText: 'Ex: 10',
                            prefixIcon: Icon(Icons.inventory_2_outlined, color: colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                            errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer la quantité en stock';
                            }
                            final parsedStock = int.tryParse(value.trim());
                            if (parsedStock == null) {
                              return 'Veuillez entrer un nombre entier valide';
                            }
                            if (parsedStock < 0) {
                              return 'La quantité ne peut pas être négative';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Statut du stock',
                            prefixIcon: Icon(Icons.trending_up, color: colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          items: const [
                            DropdownMenuItem(value: 'stable', child: Text('Stable')),
                            DropdownMenuItem(value: 'increase', child: Text('Augmentation')),
                            DropdownMenuItem(value: 'decrease', child: Text('Diminution')),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                _selectedStatus = newValue;
                              });
                            }
                          },
                          dropdownColor: colorScheme.surface,
                          icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'Annuler',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final newProduct = StockProduct(
                                    name: _nameController.text.trim(),
                                    price: double.parse(_priceController.text.trim()),
                                    stock: int.parse(_stockController.text.trim()),
                                    status: _selectedStatus,
                                  );
                                  try {
                                    if (isEditing && id != null) {
                                      await _firestore
                                          .collection('stock')
                                          .doc(id)
                                          .set(newProduct.toFirestore());
                                      _showSnackBar(
                                        context,
                                        'Produit modifié avec succès !',
                                        colorScheme.success,
                                      );
                                    } else {
                                      await _firestore
                                          .collection('stock')
                                          .add(newProduct.toFirestore());
                                      _showSnackBar(
                                        context,
                                        'Produit ajouté avec succès !',
                                        colorScheme.success,
                                      );
                                    }
                                    Navigator.pop(context);
                                    _nameController.clear();
                                    _priceController.clear();
                                    _stockController.clear();
                                  } catch (e) {
                                    _showSnackBar(
                                      context,
                                      'Erreur : $e',
                                      colorScheme.error,
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: colorScheme.primary.withOpacity(0.3),
                              ),
                              child: Text(
                                isEditing ? 'Modifier' : 'Ajouter',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await _firestore.collection('stock').doc(id).delete();
      _showSnackBar(
        context,
        'Produit supprimé.',
        Theme.of(context).colorScheme.error,
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Erreur lors de la suppression : $e',
        Theme.of(context).colorScheme.error,
      );
    }
  }

  Stream<List<StockProduct>> _getProductsStream() {
    return _firestore
        .collection('stock')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StockProduct.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  List<StockProduct> _filterProducts(List<StockProduct> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }
    return products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Gestion du Stock',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vue d\'ensemble du stock',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un produit',
                hintText: 'Entrez le nom du produit',
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: colorScheme.primary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<StockProduct>>(
              stream: _getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur : ${snapshot.error}',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                    ),
                  );
                }
                final products = snapshot.data ?? [];
                final filteredProducts = _filterProducts(products);

                return filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/inventory_empty.png',
                              width: 80,
                              height: 80,
                              color: colorScheme.onSurface.withOpacity(0.6),
                              colorBlendMode: BlendMode.modulate,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _searchQuery.isEmpty ? 'Le stock est vide.' : 'Aucun produit trouvé.',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _searchQuery.isEmpty ? 'Ajoutez des produits pour commencer !' : 'Vérifiez votre recherche ou ajoutez un nouveau produit.',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          Color statusColor;
                          String statusImage;
                          String statusText;

                          switch (product.status) {
                            case 'increase':
                              statusColor = const Color(0xFFFF4081);
                              statusImage = 'assets/images/augmenter.png';
                              statusText = 'Augmentation';
                              break;
                            case 'decrease':
                              statusColor = const Color(0xFF757575);
                              statusImage = 'assets/images/diminution.png';
                              statusText = 'Diminution';
                              break;
                            default:
                              statusColor = const Color(0xFF4CAF50);
                              statusImage = 'assets/images/equilibre (1).png';
                              statusText = 'Stable';
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Prix: ',
                                                style: textTheme.bodyMedium?.copyWith(
                                                  color: colorScheme.onSurface.withOpacity(0.7),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${product.price.toStringAsFixed(2)} DZD',
                                                style: textTheme.bodyMedium?.copyWith(
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Stock: ',
                                                style: textTheme.bodyMedium?.copyWith(
                                                  color: colorScheme.onSurface.withOpacity(0.7),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${product.stock}',
                                                style: textTheme.bodyMedium?.copyWith(
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Image.asset(
                                        statusImage,
                                        width: 28,
                                        height: 28,
                                        color: statusColor,
                                        colorBlendMode: BlendMode.modulate,
                                        semanticLabel: 'Statut: $statusText',
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        statusText,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.yellow),
                                    tooltip: 'Modifier le stock',
                                    onPressed: () {
                                      final docId = snapshot.data![index].name;
                                      _showProductDialog(product: product, id: docId);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: AppColors.primary),
                                    tooltip: 'Supprimer',
                                    onPressed: () {
                                      final docId = snapshot.data![index].name;
                                      _deleteProduct(docId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductDialog(),
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        label: Text(
          'Ajouter Produit',
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const CustomCurvedNavigationBar(),
    );
  }
}