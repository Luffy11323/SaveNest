import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savenest/product.dart';
import 'package:savenest/product_provider.dart';

class SearchProvider extends ChangeNotifier {
  Timer? _debounce;
  List<Product> _searchResults = [];
  bool _isSearching = false;

  List<Product> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  void search(String query, ProductProvider productProvider) {
    _isSearching = true;
    notifyListeners();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        _searchResults = await productProvider.searchProducts(query);
      } else {
        _searchResults = [];
      }
      _isSearching = false;
      notifyListeners();
    });
  }
}
