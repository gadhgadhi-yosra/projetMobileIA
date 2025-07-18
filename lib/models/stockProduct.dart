class StockProduct {
  final String id; // <- à ajouter
  final String name;
  final double price;
  final int stock;
  final String status;

  StockProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.status,
  });

  factory StockProduct.fromFirestore(Map<String, dynamic> data, String id) {
    return StockProduct(
      id: id, // <- important !
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      stock: (data['stock'] ?? 0).toInt(),
      status: data['status'] ?? 'stable',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'status': status,
    };
  }
}
