import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/bhub.dart';
import '../models/user.dart';
import '../models/payment.dart';
import '../models/google_auth_response.dart';
import '../utils/constants.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from secure storage
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle common errors
        if (e.response?.statusCode == 401) {
          // Handle unauthorized error
        }
        return handler.next(e);
      },
    ));
  }

  // BHub API Methods
  Future<List<BHubResponse>> getBHubs(String location) async {
    try {
      final response = await _dio.get(
        ApiConstants.bhubsEndpoint,
        queryParameters: {'location': location},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => BHubResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load BHubs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BHubResponse> getBHubById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.bhubByIdEndpoint}$id');
      
      if (response.statusCode == 200) {
        return BHubResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load BHub details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> joinBHub(BHubJoinRequest request) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.joinBhubEndpoint}${request.bhubId}',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to join BHub');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BHubCreateResponse> createBHub(BHubCreateRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.bhubsEndpoint,
        data: request.toJson(),
      );
      
      if (response.statusCode == 201) {
        return BHubCreateResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to create BHub');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // User API Methods
  Future<User> getUserById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.userByIdEndpoint}$id');
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.userByIdEndpoint}$id',
        data: data,
      );
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> createUser(String userId, String name, String email) async {
    try {
      // First check if user already exists
      try {
        final existingUser = await getUserById(userId);
        // Update user information if needed
        if (existingUser.name != name || existingUser.email != email) {
          return await updateUser(userId, {
            'name': name,
            'email': email,
          });
        }
        return existingUser; // If user exists and no updates needed, return it
      } catch (e) {
        // Only proceed with creation if user truly doesn't exist
        if (e.toString().contains('404')) {
          final data = {
            'id': userId,
            'name': name,
            'email': email,
          };
          
          final response = await _dio.post(
            ApiConstants.usersEndpoint,
            data: data,
          );
          
          if (response.statusCode == 201) {
            return User.fromJson(response.data);
          }
        }
        throw Exception('Failed to create user: $e');
      }
    } catch (e) {
      print('Error in user creation/update: $e');
      throw Exception('Error: $e');
    }
  }

  // Payment API Methods
  Future<PaymentResponse> createPayment(PaymentRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.paymentsEndpoint,
        data: request.toJson(),
      );
      
      if (response.statusCode == 201) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Payment>> getPaymentsByUserId(String userId) async {
    try {
      final response = await _dio.get('${ApiConstants.paymentsByUserEndpoint}$userId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<GoogleAuthResponse?> verifyGoogleToken(String idToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.googleLoginEndpoint,
        data: {'id_token': idToken},
      );
      
      if (response.statusCode == 200) {
        return GoogleAuthResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to verify token');
      }
    } catch (e) {
      print('Error verifying Google token: $e');
      return null;
    }
  }
}

// BHub Create Response
class BHubCreateResponse {
  final String bhubId;
  final double pricePerPerson;

  BHubCreateResponse({
    required this.bhubId,
    required this.pricePerPerson,
  });

  factory BHubCreateResponse.fromJson(Map<String, dynamic> json) {
    return BHubCreateResponse(
      bhubId: json['bhub_id'] ?? '',
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
    );
  }
}