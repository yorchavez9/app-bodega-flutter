import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/animated_car_icon.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Bodega Digital',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green,
        actions: const [
          AnimatedCartIcon(),
        ],
      ),
      body: Consumer2<ProductController, CartController>(
        builder: (context, productController, cartController, child) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!productController.isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                productController.loadMoreProducts();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: productController.products.length +
                  1, // Añadir 1 para el banner
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Banner en la parte superior
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Image.network(
                      'https://img.freepik.com/vector-gratis/plantilla-banner-venta-tiendas-comestibles_23-2151089846.jpg', // URL de la imagen del banner
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (index == productController.products.length) {
                  // Indicador de carga al final de la lista
                  return Center(
                    child: productController.isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink(),
                  );
                } else {
                  final product =
                      productController.products[index - 1]; // Ajustar índice
                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.green,
                        ),
                      ),
                      subtitle: Text(
                        '\S/${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        // Mostrar los detalles del producto en un dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(product.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Descripción: ${product.description}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Precio: \$${product.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Aquí puedes agregar más detalles si es necesario
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.green, // Color de fondo
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Bordes redondeados
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal:
                                            20), // Relleno alrededor del texto
                                    side: const BorderSide(
                                      color: Colors.green, // Borde verde
                                      width: 2,
                                    ),
                                    shadowColor:
                                        Colors.black, // Color de sombra
                                    elevation: 5, // Sombra
                                  ),
                                  child: const Text(
                                    'Cerrar',
                                    style: TextStyle(
                                      color: Colors.white, // Color del texto
                                      fontWeight: FontWeight
                                          .bold, // Hacer el texto en negrita
                                    ),
                                  ),
                                )

                              ],
                            );
                          },
                        );
                      },
                      trailing: SizedBox(
                        width: 200, // Ajustar el ancho según sea necesario
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                cartController.removeItem(product);
                              },
                            ),
                            Text(
                              '${cartController.getQuantity(product)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                cartController.addItem(product);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart,
                                  color: Colors.green),
                              onPressed: () {
                                cartController.addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product.name} añadido al carrito'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
