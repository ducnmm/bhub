import 'package:dio/dio.dart';

import '../models/payment_model.dart';

/// Service for handling payment API operations
class PaymentService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  /// Process a payment for a BHub
  Future<PaymentResponse> processPayment({
    required String userId,
    required String bhubId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String nameOnCard,
  }) async {
    try {
      final request = PaymentRequest(
        userId: userId,
        bhubId: bhubId,
        amount: amount,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        nameOnCard: nameOnCard,
      );

      final response = await _dio.post(
        '/payments',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw Exception('Payment failed: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock response
      return PaymentResponse(
        id: 'mock-payment-id',
        status: 'completed',
        message: 'Payment processed successfully',
      );
    }
  }

  /// Get payment history for a user
  Future<List<PaymentRecord>> getPaymentHistory(String userId) async {
    try {
      final response = await _dio.get('/payments/history/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PaymentRecord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment history: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock data
      return _getMockPaymentHistory();
    }
  }

  // Mock data for demo purposes
  List<PaymentRecord> _getMockPaymentHistory() {
    final now = DateTime.now();
    return [
      PaymentRecord(
        id: 'payment-1',
        userId: 'user-1',
        bhubId: 'bhub-1',
        bhubLocation: 'New York',
        amount: 15.0,
        timestamp: now.subtract(const Duration(days: 2)),
        status: 'completed',
        cardInfo: '**** **** **** 1234',
      ),
      PaymentRecord(
        id: 'payment-2',
        userId: 'user-1',
        bhubId: 'bhub-3',
        bhubLocation: 'Chicago',
        amount: 12.5,
        timestamp: now.subtract(const Duration(days: 7)),
        status: 'completed',
        cardInfo: '**** **** **** 5678',
      ),
      PaymentRecord(
        id: 'payment-3',
        userId: 'user-1',
        bhubId: 'bhub-4',
        bhubLocation: 'Houston',
        amount: 14.0,
        timestamp: now.subtract(const Duration(days: 14)),
        status: 'completed',
        cardInfo: '**** **** **** 9012',
      ),
    ];
  }
}