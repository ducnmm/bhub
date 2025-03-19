import 'package:intl/intl.dart';

/// Payment record model representing a user's payment for a BHub
class PaymentRecord {
  final String id;
  final String userId;
  final String bhubId;
  final String bhubLocation;
  final double amount;
  final DateTime timestamp;
  final String status;
  final String? cardInfo;

  PaymentRecord({
    required this.id,
    required this.userId,
    required this.bhubId,
    required this.bhubLocation,
    required this.amount,
    required this.timestamp,
    required this.status,
    this.cardInfo,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'],
      userId: json['user_id'],
      bhubId: json['bhub_id'],
      bhubLocation: json['bhub_location'],
      amount: json['amount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
      cardInfo: json['card_info'],
    );
  }
}

/// Payment request model for processing a payment
class PaymentRequest {
  final String userId;
  final String bhubId;
  final double amount;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String nameOnCard;

  PaymentRequest({
    required this.userId,
    required this.bhubId,
    required this.amount,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.nameOnCard,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bhub_id': bhubId,
      'amount': amount,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'name_on_card': nameOnCard,
    };
  }
}

/// Payment response model after processing a payment
class PaymentResponse {
  final String id;
  final String status;
  final String message;

  PaymentResponse({
    required this.id,
    required this.status,
    required this.message,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id'],
      status: json['status'],
      message: json['message'],
    );
  }
}