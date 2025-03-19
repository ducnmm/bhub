import 'package:dio/dio.dart';

import '../models/bhub_model.dart';

/// Service for handling BHub API operations
class BHubService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  /// Get a list of available BHubs
  Future<List<BHubResponse>> listBHubs() async {  // Removed location parameter
    try {
      final response = await _dio.get('/bhub/list');  // Changed to match BE endpoint
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => BHubResponse.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load BHubs: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock data
      return _getMockBHubs();
    }
  }

  /// Get a specific BHub by ID
  Future<BHubResponse> getBHub(String bhubId) async {
    try {
      final response = await _dio.get('/bhub/$bhubId');
      
      if (response.statusCode == 200) {
        return BHubResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load BHub: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock data
      return _getMockBHubs()[0];
    }
  }

  /// Join a BHub
  Future<BHubJoinResponse> joinBHub(String bhubId, String userId) async {
    try {
      final request = BHubJoinRequest(
        bhubId: bhubId,
        userId: userId,
      );
      
      final response = await _dio.post(
        '/bhub/$bhubId/join',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return BHubJoinResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to join BHub: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock response
      return BHubJoinResponse(
        message: 'Successfully joined BHub',
        totalPrice: 15.0,
      );
    }
  }

  /// Create a new BHub
  Future<BHubCreateResponse> createBHub(BHubCreateRequest request) async {
    try {
      final response = await _dio.post(
        '/bhub/create',
        data: request.toJson(),
      );
      
      if (response.statusCode == 201) {
        return BHubCreateResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create BHub: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return mock response
      return BHubCreateResponse(
        bhubId: 'mock-bhub-id',
        pricePerPerson: request.priceTotal / request.maxMembers,
      );
    }
  }

  // Mock data for demo purposes
  List<BHubResponse> _getMockBHubs() {
    final now = DateTime.now();
    return [
      BHubResponse(
        id: 'bhub-1',
        location: 'New York',
        timeSlot: DateTime(now.year, now.month, now.day + 1, 18, 0),
        currentMembers: 3,
        maxMembers: 6,
        pricePerPerson: 15.0,
        host: 'John Doe',
        status: 'open',
      ),
      BHubResponse(
        id: 'bhub-2',
        location: 'Los Angeles',
        timeSlot: DateTime(now.year, now.month, now.day + 2, 19, 30),
        currentMembers: 4,
        maxMembers: 4,
        pricePerPerson: 18.0,
        host: 'Jane Smith',
        status: 'full',
      ),
      BHubResponse(
        id: 'bhub-3',
        location: 'Chicago',
        timeSlot: DateTime(now.year, now.month, now.day + 3, 17, 0),
        currentMembers: 2,
        maxMembers: 8,
        pricePerPerson: 12.5,
        host: 'Mike Johnson',
        status: 'open',
      ),
      BHubResponse(
        id: 'bhub-4',
        location: 'Houston',
        timeSlot: DateTime(now.year, now.month, now.day + 1, 20, 0),
        currentMembers: 1,
        maxMembers: 6,
        pricePerPerson: 14.0,
        host: 'Sarah Williams',
        status: 'open',
      ),
    ];
  }
}