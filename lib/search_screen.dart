import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/product_provider.dart';
import 'package:savenest/search_provider.dart';
import 'package:savenest/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onChanged: (query) => searchProvider.search(query, productProvider),
        ),
      ),
      body: searchProvider.isSearching
          ? const Center(child: CircularProgressIndicator())
          : searchProvider.searchResults.isEmpty
          ? const Center(child: Text('No results'))
          : ListView.builder(
              itemCount: searchProvider.searchResults.length,
              itemBuilder: (context, index) {
                final product = searchProvider.searchResults[index];
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(productId: product.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
