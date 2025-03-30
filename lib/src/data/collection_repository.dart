import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/collection_item.dart';
import 'collection_data_provider.dart';

class CollectionRepository {
  final CollectionDataProvider _dataProvider;
  final Connectivity _connectivity;

  // Allow injecting dependencies for easier testing
  CollectionRepository({
    CollectionDataProvider? dataProvider,
    Connectivity? connectivity,
  })  : _dataProvider = dataProvider ?? CollectionDataProvider(),
        _connectivity = connectivity ?? Connectivity();

  // Fetches items, handling online/offline logic and caching
  Future<List<CollectionItem>> getCollectionItems({bool forceRefresh = false}) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final bool isOnline = connectivityResult.contains(ConnectivityResult.mobile) ||
                          connectivityResult.contains(ConnectivityResult.wifi);

    print("Connectivity status: $connectivityResult (Online: $isOnline)");

    if (isOnline) {
      // If online, try fetching fresh data
      try {
        print("Attempting to fetch fresh data from mock source...");
        final freshItems = await _dataProvider.fetchMockData();
        // Cache the fresh data asynchronously (don't wait for it)
        _dataProvider.cacheItems(freshItems).catchError((e) {
           print("Error caching items in background: $e");
           // Decide if this error needs further handling
        });
        print("Successfully fetched and returning fresh data.");
        return freshItems;
      } catch (e) {
        print("Failed to fetch fresh data: $e. Falling back to cache.");
        // If fetching fails, fall back to cache
        final cachedItems = await _dataProvider.getCachedItems();
        if (cachedItems.isNotEmpty) {
          print("Returning cached data after fetch failure.");
          return cachedItems;
        } else {
          print("Fetch failed and cache is empty. Throwing error.");
          // Rethrow a more specific error if needed
          throw Exception("Failed to load data online and no cache available.");
        }
      }
    } else {
      // If offline, rely solely on cache
      print("Offline. Attempting to load data from cache...");
      final cachedItems = await _dataProvider.getCachedItems();
      if (cachedItems.isNotEmpty) {
         print("Successfully loaded data from cache while offline.");
        return cachedItems;
      } else {
         print("Offline and cache is empty. Throwing error.");
        throw Exception("You are offline and no cached data is available.");
      }
    }
  }

  // Optional: Explicit refresh function (could be triggered by pull-to-refresh)
  Future<List<CollectionItem>> refreshCollectionItems() async {
     print("Explicit refresh requested.");
     // Force refresh ignores cache initially, relies on getCollectionItems logic
     return await getCollectionItems(forceRefresh: true);
  }

   // Optional: Clear cache function
  Future<void> clearCache() async {
    print("Clearing collection cache via repository.");
    await _dataProvider.clearCache();
  }
}