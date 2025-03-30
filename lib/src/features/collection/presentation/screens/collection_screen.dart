import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// Import model
import '../../../../models/whiskey.dart';
// Import AuthBloc for logout
import '../../bloc/collection_bloc.dart'; // Import CollectionBloc
// Import the bottle details screen
import 'settings_screen.dart'; // Import settings screen
// Import Details screen route name when available
// import 'details_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  // Define route name for use with go_router
  static const String routeName = '/collection'; // Matches placeholder in router

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  int _selectedIndex = 1; // Collection tab selected by default

  final List<String> _bottleImages = [
    'assets/images/samples/bottle.png',
    'assets/images/samples/bottle.png',
    'assets/images/samples/bottle.png',
    'assets/images/samples/bottle.png',
  ];

  @override
  void initState() {
    super.initState();
    // Load collection data when screen initializes
    if (context.read<CollectionBloc>().state is! CollectionLoaded) {
      context.read<CollectionBloc>().add(LoadCollection());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C21), // Updated background color to #0E1C21
      body: Stack(
        children: [
          // Main content based on selected tab
          _buildMainContent(),

          // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  // Build main content based on selected tab
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0: // Scan tab
        return const Center(
          child: Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        );
      case 1: // Collection tab
        return _buildCollectionContent();
      case 2: // Shop tab
        return const Center(
          child: Text(
            'Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        );
      case 3: // Settings tab
        return const SettingsScreen();
      default:
        return _buildCollectionContent();
    }
  }

  // Collection tab content
  Widget _buildCollectionContent() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My collection',
                  style: const TextStyle(
                    fontFamily: 'EBGaramond',
                    color: Color(0xFFE7E9EA),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Notification bell with red dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_bell.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF1F0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Collection grid
          Expanded(
            child: BlocBuilder<CollectionBloc, CollectionState>(
              builder: (context, state) {
                if (state is CollectionLoading && state is! CollectionLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFDE9A1F),
                    ),
                  );
                } else if (state is CollectionLoaded) {
                  final whiskeys = state.whiskeys;

                  if (whiskeys.isEmpty) {
                    return const Center(
                      child: Text(
                        'No whiskeys in your collection yet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<CollectionBloc>().add(RefreshCollection());
                        // Wait for refresh to complete
                        await Future.delayed(const Duration(milliseconds: 800));
                      },
                      color: const Color(0xFFDE9A1F),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.52, // Adjusted for bottle image proportions
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        physics: const BouncingScrollPhysics(), // Ensure scrolling is always enabled
                        padding: const EdgeInsets.only(
                            bottom: 100, top: 8), // Added top padding and increased bottom padding
                        itemCount: whiskeys.length,
                        itemBuilder: (context, index) {
                          final whiskey = whiskeys[index];
                          return _buildBottleCard(whiskey, index);
                        },
                      ),
                    ),
                  );
                } else if (state is CollectionError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CollectionBloc>().add(RefreshCollection());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDE9A1F),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Initial state, show empty state placeholder
                  return const Center(
                    child: Text(
                      'Loading your collection...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleCard(Whiskey whiskey, int index) {
    // Extract year from ID or use other information
    String bottleYear = "${whiskey.bottled} #${whiskey.id.split('_').last}";
    String edition = _generateEditionNumber(whiskey.id, index);

    return GestureDetector(
      onTap: () {
        // Navigate to bottle detail screen
        context.go('${CollectionScreen.routeName}/bottle/${whiskey.id}');
      },
      child: Stack(
        children: [
          // Background container with dark blue color
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF122329), // Darker background for bottle card
            ),
          ),

          // Content column
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottle image taking most of the space
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Image.asset(
                    'assets/images/one_cask_bottle.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Bottle information overlay at bottom
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        whiskey.distillery,
                        style: const TextStyle(
                          fontFamily: 'EBGaramond',
                          color: Color(0xFFE7E9EA),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        bottleYear,
                        style: const TextStyle(
                          fontFamily: 'EBGaramond',
                          color: Color(0xFFE7E9EA),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        edition,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xFFD7D5D1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to generate edition number with error handling
  String _generateEditionNumber(String id, int index) {
    try {
      final parts = id.split('_');
      if (parts.length == 2) {
        final number = int.parse(parts.last);
        return '(${number % 200 + 1}/${number % 100 + 100})';
      }
    } catch (e) {
      // Fallback to using index if id parsing fails
    }
    // Use index-based fallback without referencing whiskey object
    return index % 2 == 0
        ? "(${(index * 14 + 16)}/${(index * 24 + 94)})"
        : "(${(index * 24 + 43)}/${(index * 46 + 112)})";
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1519),
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab items row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, 'Scan', _selectedIndex == 0),
                  _buildNavItem(1, 'Collection', _selectedIndex == 1),
                  _buildNavItem(2, 'Shop', _selectedIndex == 2),
                  _buildNavItem(3, 'Settings', _selectedIndex == 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, bool isSelected) {
    // Get SVG icons from assets
    Widget getIcon(int index, bool isSelected) {
      final color = isSelected ? Colors.white : const Color(0xFF899194);
      final String iconPath;

      switch (index) {
        case 0: // Scan
          iconPath = 'assets/icons/ic_scan.svg';
          break;
        case 1: // Collection
          iconPath = 'assets/icons/ic_collection.svg';
          break;
        case 2: // Shop (bottle)
          iconPath = 'assets/icons/ic_bottle.svg';
          break;
        case 3: // Settings
          iconPath = 'assets/icons/ic_settings.svg';
          break;
        default:
          return Container();
      }

      return SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getIcon(index, isSelected),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFFE7E9EA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
