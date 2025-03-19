import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart' as app_models;
import '../models/google_auth_response.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class AuthController extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  app_models.User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  app_models.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  
  // Constructor
  AuthController() {
    // Listen to auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
    // Try to load user from storage on init
    _loadUserFromStorage();
  }
  
  // Handle auth state changes
  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      // User is signed out
      _currentUser = null;
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.userIdKey);
    } else {
      // User is signed in, get token
      final token = await firebaseUser.getIdToken();
      await _storage.write(key: AppConstants.tokenKey, value: token);
      
      // Try to get user from API if we don't have it yet
      if (_currentUser == null) {
        try {
          final userId = await _storage.read(key: AppConstants.userIdKey);
          if (userId != null) {
            _currentUser = await _apiService.getUserById(userId);
          }
        } catch (e) {
          _error = 'Failed to load user profile';
        }
      }
    }
    notifyListeners();
  }
  
  // Load user from secure storage
  Future<void> _loadUserFromStorage() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final userId = await _storage.read(key: AppConstants.userIdKey);
      if (userId != null) {
        _currentUser = await _apiService.getUserById(userId);
      }
    } catch (e) {
      _error = 'Failed to load user profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Get user from API
        final userId = userCredential.user!.uid;
        await _storage.write(key: AppConstants.userIdKey, value: userId);
        _currentUser = await _apiService.getUserById(userId);
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Authentication failed: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _auth.signOut();
      _currentUser = null;
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.userIdKey);
    } catch (e) {
      _error = 'Failed to sign out: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Register with email and password
  Future<bool> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        // Create user in API
        final userId = userCredential.user!.uid;
        await _apiService.createUser(userId, name, email);
        
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        _error = 'Sign-in was cancelled';
        return false;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      final idToken = await userCredential.user?.getIdToken();
      
      if (idToken == null) {
        _error = 'Failed to get Firebase ID token';
        return false;
      }

      final GoogleAuthResponse? response = await _apiService.verifyGoogleToken(idToken);
            
      if (response != null) {
        // Save user ID and token
        await _storage.write(key: AppConstants.userIdKey, value: response.id);
        await _storage.write(key: AppConstants.tokenKey, value: response.token);
        
        // Set current user
        _currentUser = app_models.User(
          id: response.id,
          name: response.name,
          email: response.email,
          photoUrl: response.photo_url,
        );
        
        return true;
      }
      
      _error = 'Failed to verify authentication';
      return false;
    } catch (e) {
      _error = 'Google sign-in failed: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}