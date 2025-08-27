import 'package:flutter/material.dart';
import 'package:savenest/shopping_list.dart';

class ListProvider extends ChangeNotifier {
  final List<ShoppingList> _shoppingLists = [];

  List<ShoppingList> get shoppingLists => _shoppingLists;

  void addList(String name, List<String> itemIds) {
    _shoppingLists.add(ShoppingList(name: name, itemIds: itemIds));
    notifyListeners();
  }

  // TODO: Integrate with Firestore for persistent lists if needed
}
