import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    print('🚀 Starting Google Sign In process...');

    setState(() {
      _isLoading = true;
    });

    try {
      print('👉 Getting AuthController...');
      final authController = Provider.of<AuthController>(context, listen: false);
      
      print('📱 Attempting Google Sign In...');
      // Add error handling for the sign-in process
      try {
        final success = await authController.signInWithGoogle();
        print('📢 Sign in attempt completed. Result: $success');
        
        if (!mounted) {
          print('❌ Widget not mounted after sign in');
          return;
        }

        if (success) {
          print('✅ Sign in successful! Navigating to /bhubs');
          Navigator.pushReplacementNamed(context, '/bhubs');
        } else {
          final error = authController.error;
          print('⚠️ Sign in failed with error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error ?? 'Sign in failed. Please try again.'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (signInError) {
        print('💥 Error during Google Sign In: $signInError');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign in error: ${signInError.toString()}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('💥 Critical error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('🏁 Sign in process completed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'BHub',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find your badminton group',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                OutlinedButton(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    side: BorderSide(color: colorScheme.outline),
                  ),
                  child: Image.network(
                    'https://developers.google.com/identity/images/g-logo.png',
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
