import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:savenest/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _featuredProducts = [];
  List<Product> _products = [];
  Product? _currentProduct;

  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get products => _products;
  Product? get currentProduct => _currentProduct;

  Future<void> loadFeaturedProducts() async {
    try {
      final stringData = await rootBundle.loadString(
        'assets/json/products.json',
      );
      final list = jsonDecode(stringData) as List;
      _featuredProducts = list.map((e) => Product.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    try {
      final stringData = await rootBundle.loadString(
        'assets/json/products.json',
      );
      final list = jsonDecode(stringData) as List;
      _products = list
          .where((e) => e['category'] == category)
          .map((e) => Product.fromJson(e))
          .toList();
      notifyListeners();
    } catch (e) {
      // Error
    }
  }

  Future<void> loadProductDetails(String id) async {
    try {
      final stringData = await rootBundle.loadString(
        'assets/json/products.json',
      );
      final list = jsonDecode(stringData) as List;
      _currentProduct = Product.fromJson(list.firstWhere((e) => e['id'] == id));
      notifyListeners();
    } catch (e) {
      // Error
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final stringData = await rootBundle.loadString(
        'assets/json/products.json',
      );
      final list = jsonDecode(stringData) as List;
      return list
          .where((e) => e['name'].toLowerCase().contains(query.toLowerCase()))
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, double>> getPriceComparisons(
    List<String> productIds,
  ) async {
    // TODO: Replace with actual API call
    try {
      final stringData = await rootBundle.loadString(
        'assets/json/products.json',
      );
      final list = jsonDecode(stringData) as List;
      final selectedProducts = productIds
          .map((id) => Product.fromJson(list.firstWhere((e) => e['id'] == id)))
          .toList();

      Map<String, double> comparisons = {};
      for (var product in selectedProducts) {
        for (var price in product.prices) {
          comparisons.update(
            price.store,
            (value) => value + price.price,
            ifAbsent: () => price.price,
          );
        }
      }
      return comparisons;
    } catch (e) {
      return {};
    }
  }
}
