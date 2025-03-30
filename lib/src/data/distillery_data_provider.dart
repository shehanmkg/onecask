import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/distillery.dart';
import 'local/database_helper.dart';

class DistilleryDataProvider {
  final DatabaseHelper _dbHelper;

  DistilleryDataProvider({required DatabaseHelper dbHelper}) : _dbHelper = dbHelper;

  Future<List<Distillery>> fetchMockDistilleries() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final String response = await rootBundle.loadString('assets/mock_data/distilleries.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      final distilleries = data.map((json) => Distillery.fromJson(json as Map<String, dynamic>)).toList();

      print("Fetched ${distilleries.length} distilleries from mock JSON.");

      await cacheDistilleries(distilleries);

      return distilleries;
    } catch (e) {
      print("Error fetching mock distillery data: $e");
      throw Exception("Failed to load distillery data: ${e.toString()}");
    }
  }

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

  Future<void> cacheDistilleries(List<Distillery> distilleries) async {
    try {
      await _dbHelper.upsertDistilleries(distilleries);
      print("Cached ${distilleries.length} distilleries to database.");
    } catch (e) {
      print("Error caching distilleries: $e");
    }
  }

  Future<void> clearDistilleriesCache() async {
    try {
      await _dbHelper.clearDistilleries();
      print("Cleared distilleries from database cache.");
    } catch (e) {
      print("Error clearing distilleries cache: $e");
    }
  }
}
