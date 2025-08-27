import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/cart_provider.dart';
import 'package:savenest/product_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).loadProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final product = provider.currentProduct;
    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Price Comparison',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: product.prices.map((price) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(price.link);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Could not launch ${price.link}',
                            );
                          }
                        },
                        child: Text(
                          price.store,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rs ${price.price.toStringAsFixed(2)}'),
                    ),
                  ],
                );
              }).toList(),
            ),
            if (product.nutrition.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Nutritional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (product.nutrition.isNotEmpty)
              Table(
                border: TableBorder.all(color: Colors.grey),
                children: product.nutrition.entries.map((e) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.key),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.value),
                      ),
                    ],
                  );
                }).toList(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Rating: ${product.rating.toStringAsFixed(1)} ⭐'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...product.reviews.map((review) {
              return ListTile(
                title: Text(review.user),
                subtitle: Text(review.comment),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<CartProvider>(
              context,
              listen: false,
            ).addToCart(product, 1);
            Fluttertoast.showToast(msg: 'Added to cart');
          },
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}
