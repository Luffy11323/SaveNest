import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final grouped = cartProvider.groupedByStore;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: grouped.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView(
              children: grouped.entries.map((entry) {
                final store = entry.key;
                final items = entry.value;
                final storeTotal = items.fold(
                  0.0,
                  (sum, item) =>
                      sum +
                      item.product.prices
                              .firstWhere(
                                (p) => p.store == store,
                                orElse: () => item.product.prices[0],
                              )
                              .price *
                          item.quantity,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        store,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...items.map((item) {
                      final price = item.product.prices
                          .firstWhere(
                            (p) => p.store == store,
                            orElse: () => item.product.prices[0],
                          )
                          .price;
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            item.product.imageUrl,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.product.name),
                          subtitle: Text(
                            'Quantity: ${item.quantity} | Price: Rs $price',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => cartProvider.updateQuantity(
                                  item.product.id,
                                  item.quantity - 1,
                                ),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => cartProvider.updateQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    cartProvider.removeItem(item.product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total for $store: Rs ${storeTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total: Rs ${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () => cartProvider.checkout(context),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
