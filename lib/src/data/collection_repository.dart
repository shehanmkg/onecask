import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/whiskey.dart';
import 'collection_data_provider.dart';

class CollectionRepository {
  final CollectionDataProvider _dataProvider;
  final Connectivity _connectivity;

  CollectionRepository({
    required CollectionDataProvider dataProvider,
    required Connectivity connectivity,
  })  : _dataProvider = dataProvider,
        _connectivity = connectivity;

  Future<List<Whiskey>> getWhiskeys({bool forceRefresh = false}) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final bool isOnline =
        connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;

    print("Connectivity status: $connectivityResult (Online: $isOnline)");

    try {
      print("Attempting to fetch fresh data from mock source...");
      final freshWhiskeys = await _dataProvider.fetchMockData();
      print("Successfully fetched and returning fresh data.");
      return freshWhiskeys;
    } catch (e) {
      print("Failed to fetch fresh data: $e. Falling back to cache.");
      final cachedWhiskeys = await _dataProvider.getCachedWhiskeys();
      if (cachedWhiskeys.isNotEmpty) {
        print("Returning cached data after fetch failure.");
        return cachedWhiskeys;
      } else {
        print("Fetch failed and cache is empty. Throwing error.");
        throw Exception("Failed to load data and no cache available.");
      }
    }
  }

  Future<List<Whiskey>> refreshWhiskeys() async {
    print("Explicit refresh requested.");
    return await getWhiskeys(forceRefresh: true);
  }

  Future<void> clearCache() async {
    print("Clearing collection cache via repository.");
    await _dataProvider.clearCache();
  }
}
