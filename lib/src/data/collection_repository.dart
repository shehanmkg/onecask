import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/whiskey.dart';
import 'collection_data_provider.dart';

class CollectionRepository {
  final CollectionDataProvider _dataProvider;
  final Connectivity _connectivity;

  // Allow injecting dependencies for easier testing
  CollectionRepository({
    required CollectionDataProvider dataProvider,
    required Connectivity connectivity,
  })  : _dataProvider = dataProvider,
        _connectivity = connectivity;

  // Fetches whiskeys, handling online/offline logic and caching
  Future<List<Whiskey>> getWhiskeys({bool forceRefresh = false}) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // Consider both mobile and wifi as connected
    final bool isOnline =
        connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;

    print("Connectivity status: $connectivityResult (Online: $isOnline)");

    // Force using mock data regardless of connectivity status for this demo app
    try {
      print("Attempting to fetch fresh data from mock source...");
      final freshWhiskeys = await _dataProvider.fetchMockData();
      // Cache is done in the data provider now
      print("Successfully fetched and returning fresh data.");
      return freshWhiskeys;
    } catch (e) {
      print("Failed to fetch fresh data: $e. Falling back to cache.");
      // If fetching fails, fall back to cache
      final cachedWhiskeys = await _dataProvider.getCachedWhiskeys();
      if (cachedWhiskeys.isNotEmpty) {
        print("Returning cached data after fetch failure.");
        return cachedWhiskeys;
      } else {
        print("Fetch failed and cache is empty. Throwing error.");
        // Rethrow a more specific error if needed
        throw Exception("Failed to load data and no cache available.");
      }
    }
  }

  // Optional: Explicit refresh function (could be triggered by pull-to-refresh)
  Future<List<Whiskey>> refreshWhiskeys() async {
    print("Explicit refresh requested.");
    // Force refresh ignores cache initially, relies on getWhiskeys logic
    return await getWhiskeys(forceRefresh: true);
  }

  // Optional: Clear cache function
  Future<void> clearCache() async {
    print("Clearing collection cache via repository.");
    await _dataProvider.clearCache();
  }
}
