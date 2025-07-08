import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = Product.dummyProducts;
  final List<Product> _cart = [];

  List<Product> get products => [..._products];
  List<Product> get cart => [..._cart];

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  double get cartTotal {
    return _cart.fold(0.0, (sum, item) => sum + item.price);
  }
}