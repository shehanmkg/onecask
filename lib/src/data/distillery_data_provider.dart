import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/distillery.dart';
import 'local/database_helper.dart';

class DistilleryDataProvider {
  final DatabaseHelper _dbHelper;

  DistilleryDataProvider({required DatabaseHelper dbHelper}) : _dbHelper = dbHelper;

  // Fetch mock distillery data from JSON file
  Future<List<Distillery>> fetchMockDistilleries() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final String response = await rootBundle.loadString('assets/mock_data/distilleries.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      // Simulate potential network error (uncomment to test error handling)
      // if (DateTime.now().second % 5 == 0) {
      //   throw Exception("Simulated network error");
      // }

      final distilleries = data.map((json) => Distillery.fromJson(json as Map<String, dynamic>)).toList();

      print("Fetched ${distilleries.length} distilleries from mock JSON.");

      // Cache distilleries
      await cacheDistilleries(distilleries);

      return distilleries;
    } catch (e) {
      print("Error fetching mock distillery data: $e");
      // Re-throw the exception so the Repository can handle it
      throw Exception("Failed to load distillery data: ${e.toString()}");
    }
  }

  // Get cached distilleries
  Future<List<Distillery>> getCachedDistilleries() async {
    try {
      final distilleries = await _dbHelper.getDistilleries();
      print("Retrieved ${distilleries.length} distilleries from database cache.");
      return distilleries;
    } catch (e) {
      print("Error getting cached distilleries: $e");
      return [];
    }
  }

  // Save distilleries to local database cache
  Future<void> cacheDistilleries(List<Distillery> distilleries) async {
    try {
      await _dbHelper.upsertDistilleries(distilleries);
      print("Cached ${distilleries.length} distilleries to database.");
    } catch (e) {
      print("Error caching distilleries: $e");
    }
  }

  // Clear distilleries from cache
  Future<void> clearDistilleriesCache() async {
    try {
      await _dbHelper.clearDistilleries();
      print("Cleared distilleries from database cache.");
    } catch (e) {
      print("Error clearing distilleries cache: $e");
    }
  }
}
