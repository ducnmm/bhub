class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8080';
  
  // Auth Endpoints
  static const String authEndpoint = '$baseUrl/auth';
  static const String googleLoginEndpoint = '$authEndpoint/google/login';  // Updated to match routes.go
  
  // BHub Endpoints
  static const String bhubsEndpoint = '$baseUrl/bhub';
  static const String bhubByIdEndpoint = '$baseUrl/bhub/';
  static const String joinBhubEndpoint = '$baseUrl/bhub/';
  
  // User Endpoints
  static const String usersEndpoint = '$baseUrl/users';
  static const String userByIdEndpoint = '$baseUrl/users/';
  
  // Payment Endpoints
  static const String paymentsEndpoint = '$baseUrl/payments';
  static const String paymentsByUserEndpoint = '$baseUrl/payments/user/';
}

class AppConstants {
  // App name
  static const String appName = 'BHub';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
  static const String generalErrorMessage = 'Something went wrong. Please try again later.';
}