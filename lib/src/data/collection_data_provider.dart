import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/whiskey.dart';
import 'local/database_helper.dart';

class CollectionDataProvider {
  final DatabaseHelper _dbHelper;

  CollectionDataProvider({required DatabaseHelper dbHelper}) : _dbHelper = dbHelper;

  // Simulates fetching data from a network source (by reading local JSON)
  Future<List<Whiskey>> fetchMockData() async {
    try {
      // Load mock data from JSON file
      final String response = await rootBundle.loadString('assets/mock_data/collection.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      final whiskeys = data.map((jsonItem) => Whiskey.fromJson(jsonItem as Map<String, dynamic>)).toList();
      print("Fetched ${whiskeys.length} whiskeys from mock JSON.");

      // Cache the whiskeys
      await _dbHelper.upsertWhiskeys(whiskeys);

      return whiskeys;
    } catch (e) {
      print("Error fetching mock data: $e");
      // Re-throw the exception so the Repository can handle it
      throw Exception("Failed to load collection data: ${e.toString()}");
    }
  }

  // Get items currently stored in the local database cache
  Future<List<Whiskey>> getCachedWhiskeys() async {
    try {
      final whiskeys = await _dbHelper.getWhiskeys();
      print("Retrieved ${whiskeys.length} whiskeys from database cache.");
      return whiskeys;
    } catch (e) {
      print("Error getting cached whiskeys: $e");
      return []; // Return empty list on error
    }
  }

  // Save a list of whiskeys to the local database cache (overwrites existing)
  Future<void> cacheWhiskeys(List<Whiskey> whiskeys) async {
    try {
      await _dbHelper.upsertWhiskeys(whiskeys);
      print("Cached ${whiskeys.length} whiskeys to database.");
    } catch (e) {
      print("Error caching whiskeys: $e");
    }
  }

  // Clear all whiskeys from the cache
  Future<void> clearCache() async {
    try {
      await _dbHelper.clearWhiskeys();
      print("Cleared whiskeys from database cache.");
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }
}
