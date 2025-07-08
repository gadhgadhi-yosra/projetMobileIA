import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<CompetitorPrice> competitorPrices;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.competitorPrices,
  });

  static List<Product> dummyProducts = [
    Product(
      id: 'p1',
      name: 'Lait Frais Entier',
      description: 'Lait frais entier de qualité supérieure, 1 litre.',
      price: 1.20,
      imageUrl: 'https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Produits Laitiers',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 1.25, url: 'https://www.geant.tn/lait-frais'),
        CompetitorPrice(competitor: 'Aziza', price: 1.18, url: 'https://www.aziza.tn/lait-frais'),
        CompetitorPrice(competitor: 'Jumia Food', price: 1.30, url: 'https://food.jumia.com.tn/lait-frais'),
      ],
    ),
    Product(
      id: 'p2',
      name: 'Pain Complet Bio',
      description: 'Pain complet biologique, riche en fibres, 500g.',
      price: 2.50,
      imageUrl: 'https://images.pexels.com/photos/1775043/pexels-photo-1775043.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Boulangerie',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 2.60, url: 'https://www.geant.tn/pain-complet'),
        CompetitorPrice(competitor: 'Aziza', price: 2.45, url: 'https://www.aziza.tn/pain-complet'),
        CompetitorPrice(competitor: 'Jumia Food', price: 2.70, url: 'https://food.jumia.com.tn/pain-complet'),
      ],
    ),
    Product(
      id: 'p3',
      name: 'Pommes Rouges',
      description: 'Pommes rouges croquantes et juteuses, 1 kg.',
      price: 3.00,
      imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Fruits & Légumes',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 3.10, url: 'https://www.geant.tn/pommes-rouges'),
        CompetitorPrice(competitor: 'Aziza', price: 2.90, url: 'https://www.aziza.tn/pommes-rouges'),
        CompetitorPrice(competitor: 'Jumia Food', price: 3.20, url: 'https://food.jumia.com.tn/pommes-rouges'),
      ],
    ),
    Product(
      id: 'p4',
      name: 'Eau Minérale',
      description: 'Bouteille d\'eau minérale naturelle, 1.5 litre.',
      price: 0.75,
      imageUrl: 'https://images.pexels.com/photos/261093/pexels-photo-261093.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Boissons',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 0.80, url: 'https://www.geant.tn/eau-minerale'),
        CompetitorPrice(competitor: 'Aziza', price: 0.70, url: 'https://www.aziza.tn/eau-minerale'),
        CompetitorPrice(competitor: 'Jumia Food', price: 0.85, url: 'https://food.jumia.com.tn/eau-minerale'),
      ],
    ),
    Product(
      id: 'p5',
      name: 'Café Moulu',
      description: 'Café moulu 100% Arabica, 250g.',
      price: 5.80,
      imageUrl: 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Épicerie',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 5.95, url: 'https://www.geant.tn/cafe-moulu'),
        CompetitorPrice(competitor: 'Aziza', price: 5.70, url: 'https://www.aziza.tn/cafe-moulu'),
        CompetitorPrice(competitor: 'Jumia Food', price: 6.00, url: 'https://food.jumia.com.tn/cafe-moulu'),
      ],
    ),
    Product(
      id: 'p6',
      name: 'Huile d\'Olive Extra Vierge',
      description: 'Huile d\'olive extra vierge de première pression à froid, 1 litre.',
      price: 12.50,
      imageUrl: 'https://images.pexels.com/photos/532806/pexels-photo-532806.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Épicerie',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 12.75, url: 'https://www.geant.tn/huile-olive'),
        CompetitorPrice(competitor: 'Aziza', price: 12.30, url: 'https://www.aziza.tn/huile-olive'),
        CompetitorPrice(competitor: 'Jumia Food', price: 13.00, url: 'https://food.jumia.com.tn/huile-olive'),
      ],
    ),
    Product(
      id: 'p7',
      name: 'Chocolat Noir 70%',
      description: 'Tablette de chocolat noir intense 70% cacao, 100g.',
      price: 2.80,
      imageUrl: 'https://images.pexels.com/photos/103566/pexels-photo-103566.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Confiserie',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 2.85, url: 'https://www.geant.tn/chocolat-noir'),
        CompetitorPrice(competitor: 'Aziza', price: 2.75, url: 'https://www.aziza.tn/chocolat-noir'),
        CompetitorPrice(competitor: 'Jumia Food', price: 2.90, url: 'https://food.jumia.com.tn/chocolat-noir'),
      ],
    ),
    Product(
      id: 'p8',
      name: 'Riz Basmati',
      description: 'Riz Basmati de qualité supérieure, 1 kg.',
      price: 3.50,
      imageUrl: 'https://images.pexels.com/photos/1437318/pexels-photo-1437318.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Épicerie',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 3.55, url: 'https://www.geant.tn/riz-basmati'),
        CompetitorPrice(competitor: 'Aziza', price: 3.40, url: 'https://www.aziza.tn/riz-basmati'),
        CompetitorPrice(competitor: 'Jumia Food', price: 3.60, url: 'https://food.jumia.com.tn/riz-basmati'),
      ],
    ),
    Product(
      id: 'p9',
      name: 'Lessive Liquide',
      description: 'Lessive liquide concentrée pour un linge éclatant, 2 litres.',
      price: 8.90,
      imageUrl: 'https://images.pexels.com/photos/3951389/pexels-photo-3951389.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Entretien',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 9.00, url: 'https://www.geant.tn/lessive-liquide'),
        CompetitorPrice(competitor: 'Aziza', price: 8.80, url: 'https://www.aziza.tn/lessive-liquide'),
        CompetitorPrice(competitor: 'Jumia', price: 9.20, url: 'https://www.jumia.com.tn/lessive-liquide'),
      ],
    ),
    Product(
      id: 'p10',
      name: 'Shampoing Doux',
      description: 'Shampoing doux pour usage quotidien, 400 ml.',
      price: 4.20,
      imageUrl: 'https://images.pexels.com/photos/337371/pexels-photo-337371.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      category: 'Hygiène',
      competitorPrices: [
        CompetitorPrice(competitor: 'Géant', price: 4.25, url: 'https://www.geant.tn/shampoing-doux'),
        CompetitorPrice(competitor: 'Aziza', price: 4.15, url: 'https://www.aziza.tn/shampoing-doux'),
        CompetitorPrice(competitor: 'Jumia', price: 4.30, url: 'https://www.jumia.com.tn/shampoing-doux'),
      ],
    ),
  ];
}

class CompetitorPrice {
  final String competitor;
  final double price;
  final String url;

  CompetitorPrice({
    required this.competitor,
    required this.price,
    required this.url,
  });
}