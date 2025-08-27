import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savenest/cart_item.dart';
import 'package:savenest/product.dart';
import 'package:savenest/user_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product, int quantity) {
    final existing = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existing.quantity > 0) {
      existing.quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(
          id: '',
          name: '',
          description: '',
          imageUrl: '',
          prices: [],
          nutrition: {},
          rating: 0,
          reviews: [],
          category: '',
        ),
        quantity: 0,
      ),
    );
    if (item.quantity == 0) return;
    item.quantity = quantity;
    if (item.quantity <= 0) {
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + item.product.prices[0].price * item.quantity,
    );
  }

  Map<String, List<CartItem>> get groupedByStore {
    Map<String, List<CartItem>> grouped = {};
    for (var item in _cartItems) {
      for (var price in item.product.prices) {
        grouped.update(
          price.store,
          (list) => list..add(item),
          ifAbsent: () => [item],
        );
      }
    }
    return grouped;
  }

  Future<void> checkout(BuildContext context) async {
    if (_cartItems.isEmpty) return;
    // TODO: Replace with actual API call for payment/checkout
    final order = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'items': _cartItems
          .map(
            (e) => {
              'productId': e.product.id,
              'quantity': e.quantity,
              'name': e.product.name,
            },
          )
          .toList(),
      'total': totalPrice,
      'date': DateTime.now().toIso8601String(),
    };
    await Provider.of<UserProvider>(context, listen: false).addOrder(order);
    _cartItems.clear();
    Fluttertoast.showToast(msg: 'Checkout successful. Order placed.');
    notifyListeners();
  }
}
