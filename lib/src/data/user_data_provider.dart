import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/user.dart';
import 'local/database_helper.dart';

class UserDataProvider {
  final DatabaseHelper _dbHelper;

  UserDataProvider({required DatabaseHelper dbHelper}) : _dbHelper = dbHelper;

  // Fetch mock user data from JSON file
  Future<User> fetchMockUser() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final String response = await rootBundle.loadString('assets/mock_data/user.json');
      final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;

      // Simulate potential network error (uncomment to test error handling)
      // if (DateTime.now().second % 5 == 0) {
      //   throw Exception("Simulated network error");
      // }

      final user = User.fromJson(data);
      print("Fetched user data from mock JSON.");

      // Cache user data
      await cacheUser(user);

      return user;
    } catch (e) {
      print("Error fetching mock user data: $e");
      // Re-throw the exception so the Repository can handle it
      throw Exception("Failed to load user data: ${e.toString()}");
    }
  }

  // Get cached user
  Future<User?> getCachedUser() async {
    try {
      final user = await _dbHelper.getUser();
      if (user != null) {
        print("Retrieved user from database cache.");
      } else {
        print("No user found in cache.");
      }
      return user;
    } catch (e) {
      print("Error getting cached user: $e");
      return null;
    }
  }

  // Save user to local database cache
  Future<void> cacheUser(User user) async {
    try {
      await _dbHelper.upsertUser(user);
      print("Cached user to database.");
    } catch (e) {
      print("Error caching user: $e");
    }
  }

  // Clear user from cache
  Future<void> clearUserCache() async {
    try {
      await _dbHelper.clearUser();
      print("Cleared user from database cache.");
    } catch (e) {
      print("Error clearing user cache: $e");
    }
  }
}
