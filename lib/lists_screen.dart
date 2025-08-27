import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/compare_prices_screen.dart';
import 'package:savenest/list_provider.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    // For demo, add mock lists if empty
    if (listProvider.shoppingLists.isEmpty) {
      listProvider.addList('Grocery Shopping', ['1', '2', '3', '4']);
      listProvider.addList('Weekly Essentials', ['5', '6']);
      listProvider.addList('Party Supplies', ['7']);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Lists')),
      body: ListView.builder(
        itemCount: listProvider.shoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = listProvider.shoppingLists[index];
          return ListTile(
            title: Text(shoppingList.name),
            subtitle: Text('${shoppingList.itemIds.length} items'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComparePricesScreen(
                    listName: shoppingList.name,
                    itemIds: shoppingList.itemIds,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () {
          // Dynamic add list form
          showDialog(
            context: context,
            builder: (context) {
              final nameController = TextEditingController();
              return AlertDialog(
                title: const Text('New List'),
                content: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'List Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        listProvider.addList(nameController.text, []);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
