import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/product_provider.dart';

class ComparePricesScreen extends StatelessWidget {
  final String listName;
  final List<String> itemIds;

  const ComparePricesScreen({
    super.key,
    required this.listName,
    required this.itemIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Prices')),
      body: FutureBuilder<Map<String, double>>(
        future: Provider.of<ProductProvider>(
          context,
          listen: false,
        ).getPriceComparisons(itemIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading comparisons'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comparisons available'));
          }

          final comparisons = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    listName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Shopping List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Assume item names from IDs - in real, fetch names
                ...itemIds.map(
                  (id) => ListTile(title: Text('Item ID: $id')),
                ), // TODO: Fetch actual names
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
                  children: comparisons.entries.map((e) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Rs ${e.value.toStringAsFixed(2)}'),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
