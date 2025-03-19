import 'package:flutter/material.dart';

import '../models/bhub.dart';
import '../services/api_service.dart';

class BHubController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<BHubResponse> _bhubs = [];
  BHubResponse? _selectedBHub;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<BHubResponse> get bhubs => _bhubs;
  BHubResponse? get selectedBHub => _selectedBHub;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch BHubs by location
  Future<void> fetchBHubs(String location) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _bhubs = await _apiService.getBHubs(location);
    } catch (e) {
      _error = 'Failed to load BHubs: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get BHub details by ID
  Future<void> getBHubDetails(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _selectedBHub = await _apiService.getBHubById(id);
    } catch (e) {
      _error = 'Failed to load BHub details: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Join BHub
  Future<Map<String, dynamic>?> joinBHub(String userId, String bhubId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final request = BHubJoinRequest(userId: userId, bhubId: bhubId);
      final response = await _apiService.joinBHub(request);
      
      // Refresh BHub details after joining
      await getBHubDetails(bhubId);
      
      return response;
    } catch (e) {
      _error = 'Failed to join BHub: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Create BHub
  Future<BHubCreateResponse?> createBHub(BHubCreateRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await _apiService.createBHub(request);
      return response;
    } catch (e) {
      _error = 'Failed to create BHub: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Clear selected BHub
  void clearSelectedBHub() {
    _selectedBHub = null;
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}