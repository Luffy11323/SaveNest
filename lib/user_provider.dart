import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      if (user != null) {
        loadUserData(); // Trigger data load on auth state change
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();
    if (doc.exists) {
      _userData = doc.data();
    } else {
      _userData = null;
    }
    notifyListeners();
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .update(data);
    await loadUserData();
  }

  Future<void> createUserData(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .set(data);
    await loadUserData();
  }

  Future<void> addOrder(Map<String, dynamic> order) async {
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update(
      {
        'orders': FieldValue.arrayUnion([order]),
      },
    );
    await loadUserData();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
