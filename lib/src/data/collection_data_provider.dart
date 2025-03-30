import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/collection_item.dart';
import 'local/database_helper.dart';

class CollectionDataProvider {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Simulates fetching data from a network source (by reading local JSON)
  Future<List<CollectionItem>> fetchMockData() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final String response = await rootBundle.loadString('assets/mock_data/collection.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      // Simulate potential network error (uncomment to test error handling)
      // if (DateTime.now().second % 2 == 0) {
      //   throw Exception("Simulated network error");
      // }

      final items = data.map((jsonItem) => CollectionItem.fromJson(jsonItem as Map<String, dynamic>)).toList();
      print("Fetched ${items.length} items from mock JSON.");
      return items;

    } catch (e) {
      print("Error fetching mock data: $e");
      // Re-throw the exception so the Repository can handle it
      throw Exception("Failed to load collection data: ${e.toString()}");
    }
  }

  // Get items currently stored in the local database cache
  Future<List<CollectionItem>> getCachedItems() async {
    try {
      final items = await _dbHelper.getCollectionItems();
      print("Retrieved ${items.length} items from database cache.");
      return items;
    } catch (e) {
      print("Error getting cached items: $e");
      return []; // Return empty list on error
    }
  }

  // Save a list of items to the local database cache (overwrites existing)
  Future<void> cacheItems(List<CollectionItem> items) async {
    try {
      // Consider clearing before upserting if you always want a fresh cache
      // await _dbHelper.clearCollectionItems();
      await _dbHelper.upsertCollectionItems(items);
      print("Cached ${items.length} items to database.");
    } catch (e) {
      print("Error caching items: $e");
      // Decide if error should be propagated
    }
  }

   // Clear all items from the cache
  Future<void> clearCache() async {
     try {
      await _dbHelper.clearCollectionItems();
      print("Cleared database cache.");
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }
}