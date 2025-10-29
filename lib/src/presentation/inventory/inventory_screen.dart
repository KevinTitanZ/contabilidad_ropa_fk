import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {'name': 'Product 1', 'price': '10.00'},
      {'name': 'Product 2', 'price': '20.00'},
      {'name': 'Product 3', 'price': '30.00'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario - Productos')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']!),
            subtitle: Text('Precio: ${product['price']}'),
          );
        },
      ),
    );
  }
}
