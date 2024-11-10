class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String description; // Agregar descripción

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description, // Asegúrate de pasar la descripción en el constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // Conversión a double
      stock: json['stock'],
      description:
          json['description'] ?? '', // Asegúrate de asignar la descripción
    );
  }
}
