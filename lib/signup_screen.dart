import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savenest/user_provider.dart';
import 'package:savenest/main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || email.isEmpty || address.isEmpty) {
      Fluttertoast.showToast(msg: 'All fields are required');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Invalid email format');
      return;
    }

    final data = {
      'name': name,
      'email': email,
      'address': address,
      'phone': Provider.of<UserProvider>(
        context,
        listen: false,
      ).user!.phoneNumber,
      'orders': [],
      'favoriteStores': [],
      'dietaryRestrictions': [],
    };

    await Provider.of<UserProvider>(
      context,
      listen: false,
    ).createUserData(data);
    if (context.mounted)
      // ignore: curly_braces_in_flow_control_structures
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _signup, child: const Text('Signup')),
          ],
        ),
      ),
    );
  }
}
