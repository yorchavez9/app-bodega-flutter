import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'views/product_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ProductController()..fetchProducts()),
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          hintColor: Colors.orange,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.indigo),
            bodyMedium: TextStyle(color: Colors.indigo),
          ),
        ),
        home: const ProductListView(),
      ),
    );
  }
}
