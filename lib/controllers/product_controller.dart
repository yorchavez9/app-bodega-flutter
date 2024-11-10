import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController with ChangeNotifier {
  List<Product> _products = [];
  Map<String, int> _cart = {};
  bool _isLoading = false; // Nueva variable para gestionar el estado de carga
  final Map<Product, int> _items = {};
  List<Product> get products => _products;

  List<CartItem> get cartItems => _cart.entries.map((entry) {
        final product =
            _products.firstWhere((product) => product.id == entry.key);
        return CartItem(product: product, quantity: entry.value);
      }).toList();

  bool get isLoading => _isLoading; // Getter para el estado de carga

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    final response =
        await http.get(Uri.parse('https://shop-api-roan.vercel.app/product'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _products = data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }

    _isLoading = false;
    notifyListeners();
  }

  void addToCart(String productId) {
    if (_cart.containsKey(productId)) {
      _cart[productId] = _cart[productId]! + 1;
    } else {
      _cart[productId] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_cart.containsKey(productId) && _cart[productId]! > 1) {
      _cart[productId] = _cart[productId]! - 1;
    } else {
      _cart.remove(productId);
    }
    notifyListeners();
  }

  void loadMoreProducts() {
    // Implementación de carga de más productos
  }

  void addItem(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  String get name => product.name;
  double get price => product.price;
  String get description => product.description; // Agregar la descripción aquí
}
