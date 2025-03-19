import 'package:flutter/material.dart';

import '../models/payment.dart';
import '../services/api_service.dart';

class PaymentController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Payment> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Create payment
  Future<PaymentResponse?> createPayment(String userId, String bhubId, double amount) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final request = PaymentRequest(
        userId: userId,
        bhubId: bhubId,
        amount: amount,
      );
      
      final response = await _apiService.createPayment(request);
      return response;
    } catch (e) {
      _error = 'Failed to process payment: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get payment history for a user
  Future<void> getPaymentHistory(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _payments = await _apiService.getPaymentsByUserId(userId);
    } catch (e) {
      _error = 'Failed to load payment history: ${e.toString()}';
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
}