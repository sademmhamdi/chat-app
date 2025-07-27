import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? get user => _auth.currentUser;
  UserModel? _currentUserModel;
  UserModel? get currentUserModel => _currentUserModel;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      notifyListeners();
      if (user != null) {
        _loadUserModel();
        _updateOnlineStatus(true);
      }
    });
  }

  Future<void> _loadUserModel() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        _currentUserModel = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    }
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> createUserWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      final userModel = UserModel(
        uid: result.user!.uid,
        email: email,
        displayName: displayName,
        lastSeen: DateTime.now(),
        isOnline: true,
      );

      await _firestore.collection('users').doc(result.user!.uid).set(userModel.toMap());
      _currentUserModel = userModel;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _updateOnlineStatus(false);
    await _auth.signOut();
    _currentUserModel = null;
    notifyListeners();
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}