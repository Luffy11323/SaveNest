import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/product_provider.dart';
import 'package:savenest/product_details_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String category;

  const ProductListingScreen({super.key, required this.category});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).loadProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: provider.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                final minPrice = product.prices
                    .map((p) => p.price)
                    .reduce((a, b) => a < b ? a : b);
                final maxPrice = product.prices
                    .map((p) => p.price)
                    .reduce((a, b) => a > b ? a : b);
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text('Rs $minPrice - $maxPrice'),
                    trailing: ElevatedButton(
                      child: const Text('Compare Prices'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(productId: product.id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
