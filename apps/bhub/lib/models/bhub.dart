import 'package:intl/intl.dart';

class BHubResponse {
  final String id;
  final String name;
  final String location;
  final String description;
  final int capacity;
  final String status;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final DateTime availableFrom;
  final DateTime availableTo;
  final double pricePerHour;

  BHubResponse({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.capacity,
    required this.status,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.availableFrom,
    required this.availableTo,
    required this.pricePerHour,
  });

  factory BHubResponse.fromJson(Map<String, dynamic> json) {
    return BHubResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'available',
      amenities: json['amenities'] != null 
          ? List<String>.from(json['amenities']) 
          : [],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      availableFrom: json['available_from'] != null 
          ? DateTime.parse(json['available_from']) 
          : DateTime.now(),
      availableTo: json['available_to'] != null 
          ? DateTime.parse(json['available_to']) 
          : DateTime.now(),
      pricePerHour: (json['price_per_hour'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'capacity': capacity,
      'status': status,
      'amenities': amenities,
      'rating': rating,
      'review_count': reviewCount,
      'image_url': imageUrl,
      'available_from': formatter.format(availableFrom),
      'available_to': formatter.format(availableTo),
      'price_per_hour': pricePerHour,
    };
  }
}

class BHub {
  final String id;
  final String hostId;
  final String location;
  final DateTime timeSlot;
  final int minMembers;
  final int maxMembers;
  final double priceTotal;
  final double pricePerPerson;
  final String status;
  final List<String> members;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String hostName; // Added for UI display

  BHub({
    required this.id,
    required this.hostId,
    required this.location,
    required this.timeSlot,
    required this.minMembers,
    required this.maxMembers,
    required this.priceTotal,
    required this.pricePerPerson,
    required this.status,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    this.hostName = '',
  });

  // Create BHub from JSON
  factory BHub.fromJson(Map<String, dynamic> json) {
    return BHub(
      id: json['id'] ?? '',
      hostId: json['host_id'] ?? '',
      location: json['location'] ?? '',
      timeSlot: json['time_slot'] != null 
          ? DateTime.parse(json['time_slot']) 
          : DateTime.now(),
      minMembers: json['min_members'] ?? 0,
      maxMembers: json['max_members'] ?? 0,
      priceTotal: (json['price_total'] ?? 0).toDouble(),
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
      status: json['status'] ?? 'open',
      members: json['members'] != null 
          ? List<String>.from(json['members']) 
          : [],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      hostName: json['host'] ?? '',
    );
  }

  // Create BHub from BHubResponse JSON
  factory BHub.fromBHubResponse(Map<String, dynamic> json) {
    return BHub(
      id: json['id'] ?? '',
      hostId: '', // Not provided in BHubResponse
      location: json['location'] ?? '',
      timeSlot: json['time_slot'] != null 
          ? DateTime.parse(json['time_slot']) 
          : DateTime.now(),
      minMembers: 0, // Not provided in BHubResponse
      maxMembers: json['max_members'] ?? 0,
      priceTotal: 0, // Not provided in BHubResponse
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
      status: json['status'] ?? 'open',
      members: [], // Not provided in BHubResponse
      createdAt: DateTime.now(), // Not provided in BHubResponse
      updatedAt: DateTime.now(), // Not provided in BHubResponse
      hostName: json['host'] ?? '',
    );
  }

  // Format time slot for display
  String get formattedTimeSlot {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(timeSlot)} at ${timeFormat.format(timeSlot)}';
  }

  // Get current number of members
  int get currentMembers => members.length;

  // Check if BHub is full
  bool get isFull => currentMembers >= maxMembers;

  // Check if BHub is open for joining
  bool get isOpen => status == 'open';
}

// BHub Create Request
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
      'time_slot': timeSlot.toIso8601String(),
      'min_members': minMembers,
      'max_members': maxMembers,
      'price_total': priceTotal,
    };
  }
}

// BHub Join Request
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