import 'package:intl/intl.dart';

/// BHub model representing a badminton hub group
class BHubResponse {
  final String id;
  final String location;
  final DateTime timeSlot;
  final int currentMembers;
  final int maxMembers;
  final double pricePerPerson;
  final String host;
  final String status;

  BHubResponse({
    required this.id,
    required this.location,
    required this.timeSlot,
    required this.currentMembers,
    required this.maxMembers,
    required this.pricePerPerson,
    required this.host,
    required this.status,
  });

  factory BHubResponse.fromJson(Map<String, dynamic> json) {
    return BHubResponse(
      id: json['id'] ?? '',
      location: json['location'] ?? '',
      timeSlot: json['time_slot'] != null ? DateTime.parse(json['time_slot']) : DateTime.now(),
      currentMembers: json['current_members'] ?? 0,
      maxMembers: json['max_members'] ?? 0,
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
      host: json['host'] ?? '',
      status: json['status'] ?? 'open',
    );
  }
}

/// Request model for joining a BHub
class BHubJoinRequest {
  final String userId;
  final String bhubId;

  BHubJoinRequest({
    required this.userId,
    required this.bhubId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bhub_id': bhubId,
    };
  }
}

/// Response model after joining a BHub
class BHubJoinResponse {
  final String message;
  final double totalPrice;

  BHubJoinResponse({
    required this.message,
    required this.totalPrice,
  });

  factory BHubJoinResponse.fromJson(Map<String, dynamic> json) {
    return BHubJoinResponse(
      message: json['message'],
      totalPrice: json['total_price'].toDouble(),
    );
  }
}

/// Request model for creating a new BHub
class BHubCreateRequest {
  final String hostId;
  final String location;
  final DateTime timeSlot;
  final int minMembers;
  final int maxMembers;
  final double priceTotal;

  BHubCreateRequest({
    required this.hostId,
    required this.location,
    required this.timeSlot,
    required this.minMembers,
    required this.maxMembers,
    required this.priceTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'host_id': hostId,
      'location': location,
      'time_slot': DateFormat("yyyy-MM-ddTHH:mm:ss").format(timeSlot),
      'min_members': minMembers,
      'max_members': maxMembers,
      'price_total': priceTotal,
    };
  }
}

/// Response model after creating a BHub
class BHubCreateResponse {
  final String bhubId;
  final double pricePerPerson;

  BHubCreateResponse({
    required this.bhubId,
    required this.pricePerPerson,
  });

  factory BHubCreateResponse.fromJson(Map<String, dynamic> json) {
    return BHubCreateResponse(
      bhubId: json['bhub_id'],
      pricePerPerson: json['price_per_person'].toDouble(),
    );
  }
}