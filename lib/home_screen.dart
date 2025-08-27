import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/cart_screen.dart';
import 'package:savenest/product_listing_screen.dart';
import 'package:savenest/product_details_screen.dart';
import 'package:savenest/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Grocery',
    'Furniture',
    'Utilities',
    'Electronics',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadFeaturedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveNest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.featuredProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListingScreen(
                                    category: categories[index],
                                  ),
                                ),
                              );
                            },
                            child: Chip(label: Text(categories[index])),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Daily Essentials',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: PageView.builder(
                      itemCount: provider.featuredProducts.length,
                      itemBuilder: (context, index) {
                        final product = provider.featuredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(productId: product.id),
                              ),
                            );
                          },
                          child: Card(
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Suggested for You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = provider.featuredProducts[index];
                      final minPrice = product.prices
                          .map((p) => p.price)
                          .reduce((a, b) => a < b ? a : b);
                      final maxPrice = product.prices
                          .map((p) => p.price)
                          .reduce((a, b) => a > b ? a : b);
                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text('Rs $minPrice - $maxPrice'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(productId: product.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
