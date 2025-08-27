import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savenest/login_screen.dart';
import 'package:savenest/theme_provider.dart';
import 'package:savenest/user_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userData = userProvider.userData;

    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final orders = userData['orders'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
              ), // TODO: Add profile photo from Firestore if added
              title: Text(userData['name']),
              subtitle: Text(userData['email']),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (orders.isEmpty) const Center(child: Text('No orders yet')),
            ...orders.map((order) {
              return ListTile(
                title: Text('Order #${order['id']}'),
                subtitle: Text(
                  '${order['items'].length} items - Rs ${order['total'].toStringAsFixed(2)}',
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // View order details
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Order #${order['id']}'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: order['items']
                            .map<Widget>(
                              (item) => ListTile(
                                title: Text(item['name']),
                                subtitle: Text('Qty: ${item['quantity']}'),
                              ),
                            )
                            .toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text('Favorite Stores'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Edit favorites
              },
            ),
            ListTile(
              title: const Text('Dietary Restrictions'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Edit restrictions
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            const Divider(),
            ListTile(
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Notification settings
              },
            ),
            const ListTile(title: Text('App Version'), trailing: Text('1.2.3')),
            ListTile(
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await userProvider.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
