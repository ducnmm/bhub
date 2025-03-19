import 'package:intl/intl.dart';

class Payment {
  final String id;
  final String userId;
  final String bhubId;
  final double amount;
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Additional fields for UI display
  final String bhubLocation;
  final DateTime bhubTimeSlot;
  
  Payment({
    required this.id,
    required this.userId,
    required this.bhubId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.bhubLocation = '',
    DateTime? bhubTimeSlot,
  }) : bhubTimeSlot = bhubTimeSlot ?? DateTime.now();
  
  // Create Payment from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      bhubId: json['bhub_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      bhubLocation: json['bhub_location'] ?? '',
      bhubTimeSlot: json['bhub_time_slot'] != null
          ? DateTime.parse(json['bhub_time_slot'])
          : DateTime.now(),
    );
  }
  
  // Convert Payment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bhub_id': bhubId,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  // Format amount as currency
  String get formattedAmount {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return currencyFormat.format(amount);
  }
  
  // Format date for display
  String get formattedDate {
    final dateFormat = DateFormat('MMM d, yyyy');
    return dateFormat.format(createdAt);
  }
  
  // Get status color
  String get statusColor {
    switch (status) {
      case 'completed':
        return '#4CAF50'; // Green
      case 'pending':
        return '#FFC107'; // Amber
      case 'failed':
        return '#F44336'; // Red
      case 'refunded':
        return '#2196F3'; // Blue
      default:
        return '#9E9E9E'; // Grey
    }
  }
}

// Payment Request
class PaymentRequest {
  final String userId;
  final String bhubId;
  final double amount;
  
  PaymentRequest({
    required this.userId,
    required this.bhubId,
    required this.amount,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bhub_id': bhubId,
      'amount': amount,
    };
  }
}

// Payment Response
class PaymentResponse {
  final String paymentId;
  final String status;
  final String message;
  
  PaymentResponse({
    required this.paymentId,
    required this.status,
    required this.message,
  });
  
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      paymentId: json['payment_id'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}