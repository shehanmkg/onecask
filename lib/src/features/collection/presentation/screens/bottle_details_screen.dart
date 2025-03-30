import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottleDetailsScreen extends StatefulWidget {
  final String bottleId;

  const BottleDetailsScreen({
    super.key,
    required this.bottleId,
  });

  static const String routeName = 'bottle-details';

  @override
  State<BottleDetailsScreen> createState() => _BottleDetailsScreenState();
}

class _BottleDetailsScreenState extends State<BottleDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  // Animation controllers
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  // Separate animation controller for shimmer to avoid lifecycle issues
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;

    // Initialize expand animation controller
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // Create animations
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    // Create separate shimmer controller with repeating animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_shimmerController);

    // Start or set initial animations
    if (_isExpanded) {
      _expandController.value = 1.0;
    }

    // Listener to control shimmer animation based on expanded state
    _expandController.addStatusListener((status) {
      if (status == AnimationStatus.forward || status == AnimationStatus.completed) {
        if (!_shimmerController.isAnimating) {
          _shimmerController.repeat(reverse: true);
        }
      } else {
        _shimmerController.stop();
        _shimmerController.reset();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _expandController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // Toggle the expansion state with animation
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1519), // Updated darker background color
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with collection name and close button
              _buildTopBar(),

              // Bottle type / authenticity section
              _buildAuthenticitySection(),

              const SizedBox(height: 25),

              // Rest of content in scrollable area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Bottle image
                      SizedBox(
                        height: size.height * 0.4,
                        child: Center(
                          child: Image.asset(
                            'assets/images/one_cask_bottle.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.photo_outlined,
                                color: Color(0xFFDE9A1F),
                                size: 120,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Bottle information container
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        color: const Color(0xFF122329), // Slightly lighter blue with opacity
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bottle number
                            Text(
                              'Bottle 135/184',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFFB8BDBF),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Bottle title with colored year
                            Row(
                              children: [
                                Text(
                                  'Talisker ',
                                  style: const TextStyle(
                                    fontFamily: 'EBGaramond',
                                    color: Color(0xFFE7E9EA),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '18 Year old',
                                  style: const TextStyle(
                                    fontFamily: 'EBGaramond',
                                    color: Color(0xFFD49A00),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            // Bottle ID
                            Text(
                              '#2504',
                              style: const TextStyle(
                                fontFamily: 'EBGaramond',
                                color: Color(0xFFE7E9EA),
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tabs
                            _buildTabBar(),

                            const SizedBox(height: 24),

                            // Tab content
                            _buildTabContent(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add to collection button - moved outside the tab content container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 24,
                            color: Color(0xFF0B1519),
                          ),
                          label: const Text(
                            'Add to my collection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0B1519),
                              fontFamily: 'EBGaramond',
                              letterSpacing: 0.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD49A00),
                            foregroundColor: const Color(0xFF0E1C21),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 3,
                            shadowColor: const Color(0xFF0B1519).withValues(alpha: 0.3),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1519),
            ),
            child: const Text(
              'Genesis Collection',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                fontSize: 12,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1519),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(24, 24),
                  painter: CrossPainter(color: const Color(0xFFE7E9EA)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticitySection() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleExpansion,
        splashColor: const Color(0xFFDE9A1F).withValues(alpha: 0.1),
        highlightColor: const Color(0xFFDE9A1F).withValues(alpha: 0.05),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1519),
            border: Border.all(
              color: const Color(0xFF0E1C21),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Genuine bottle icon with subtle pulse animation on tap
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      boxShadow: _isExpanded
                          ? [
                              BoxShadow(
                                color: const Color(0xFFDE9A1F).withAlpha(20),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: Image.asset(
                      'assets/images/logo_genuine.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text
                  Expanded(
                    child: const Text(
                      'Genuine Bottle (Unopened)',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xFFE7E9EA),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Animated rotating dropdown arrow
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFFDE9A1F),
                      size: 28,
                    ),
                  ),
                ],
              ),

              // Animated expanding content
              ClipRect(
                child: AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1F2E),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerTitle(),
                            const SizedBox(height: 8),
                            const Text(
                              'This bottle has been verified as genuine by One Cask experts. The bottle is unopened and in mint condition.',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFFD7D5D1),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verified Date',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xFFDE9A1F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '12 March 2024',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xFFE7E9EA),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verified By',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xFFDE9A1F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'One Cask Expert',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xFFE7E9EA),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: const Color(0xFF0E1C21),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFD49A00),
          borderRadius: BorderRadius.circular(6),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: const EdgeInsets.all(3),
        labelColor: const Color(0xFF0B1519),
        unselectedLabelColor: const Color(0xFF899194),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lato',
        ),
        tabs: const [
          SizedBox(
            height: 36,
            child: Center(child: Text('Details')),
          ),
          SizedBox(
            height: 36,
            child: Center(child: Text('Tasting notes')),
          ),
          SizedBox(
            height: 36,
            child: Center(child: Text('History')),
          ),
        ],
        onTap: (index) {
          setState(() {
            // Update state when tab changes to rebuild content
          });
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0: // Details tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Distillery', 'Text'),
            _buildDetailRow('Region', 'Text'),
            _buildDetailRow('Country', 'Text'),
            _buildDetailRow('Type', 'Text'),
            _buildDetailRow('Age statement', 'Text'),
            _buildDetailRow('Filled', 'Text'),
            _buildDetailRow('Bottled', 'Text'),
            _buildDetailRow('Cask number', 'Text'),
            _buildDetailRow('ABV', 'Text'),
            _buildDetailRow('Size', 'Text'),
            _buildDetailRow('Finish', 'Text'),
          ],
        );
      case 1: // Tasting notes tab
        return _buildTastingNotesContent();
      case 2: // History tab
        return _buildHistoryTimeline();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTastingNotesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video thumbnail with play button overlay
        Container(
          width: double.infinity,
          height: 180,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1519),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dark background for video
              Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF0A1519),
              ),
              // Play button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white.withOpacity(0.9),
                  size: 30,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Title and expert
        const Text(
          'Tasting notes',
          style: TextStyle(
            fontFamily: 'EBGaramond',
            color: Color(0xFFE7E9EA),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'by Charles MacLean MBE',
          style: TextStyle(
            fontFamily: 'Lato',
            color: Color(0xFFD49A00),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
        ),

        const SizedBox(height: 24),

        // Nose section
        _buildTastingNotesSection(
          title: 'Nose',
          descriptions: const [
            'Description',
            'Description',
            'Description',
          ],
        ),

        const SizedBox(height: 24),

        // Palate section
        _buildTastingNotesSection(
          title: 'Palate',
          descriptions: const [
            'Description',
            'Description',
            'Description',
          ],
        ),

        const SizedBox(height: 24),

        // Finish section
        _buildTastingNotesSection(
          title: 'Finish',
          descriptions: const [
            'Description',
            'Description',
            'Description',
          ],
        ),
      ],
    );
  }

  Widget _buildTastingNotesSection({
    required String title,
    required List<String> descriptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'EBGaramond',
            color: Color(0xFFE7E9EA),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        ...descriptions
            .map((description) => Padding(
                  padding: const EdgeInsets.only(bottom: 6), // slightly more spacing
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xFFB8BDBF),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildHistoryTimeline() {
    return Stack(
      children: [
        // Add a continuous vertical line behind everything
        Positioned(
          left: 11.5, // Position to align with timeline indicators
          top: 12,
          bottom: 12,
          width: 2,
          child: Container(
            color: const Color(0xFFD49A00),
          ),
        ),
        // The actual timeline
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // First timeline entry
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // White circle
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Label',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Title',
                          style: const TextStyle(
                            fontFamily: 'EBGaramond',
                            color: Color(0xFFE7E9EA),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Description',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Description',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAttachmentsSection(),
                      ],
                    ),
                  ),
                ],
              ),

              // Diamond markers
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Transform.rotate(
                      angle: 0.785398, // 45 degrees in radians
                      child: Container(
                        width: 6,
                        height: 6,
                        color: const Color(0xFFD49A00),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Transform.rotate(
                      angle: 0.785398, // 45 degrees in radians
                      child: Container(
                        width: 10,
                        height: 10,
                        color: const Color(0xFFD49A00),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Transform.rotate(
                      angle: 0.785398, // 45 degrees in radians
                      child: Container(
                        width: 6,
                        height: 6,
                        color: const Color(0xFFD49A00),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Second timeline entry
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // White circle
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Label',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Title',
                          style: const TextStyle(
                            fontFamily: 'EBGaramond',
                            color: Color(0xFFE7E9EA),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Description',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Description',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFB8BDBF),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAttachmentsSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attachment header with link icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.link,
              color: Color(0xFFE7E9EA),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Attachments',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Attachment thumbnails
        Row(
          children: [
            _buildSquareAttachment(),
            const SizedBox(width: 8),
            _buildSquareAttachment(),
            const SizedBox(width: 8),
            _buildSquareAttachment(),
          ],
        ),
      ],
    );
  }

  Widget _buildSquareAttachment() {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xFFB8BDBF),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Add custom shimmer widget for the title
  Widget _buildShimmerTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        // Use a simple TweenSequence to oscillate between colors
        final color = ColorTween(
          begin: const Color(0xFFE7E9EA),
          end: const Color(0xFFDE9A1F),
        ).transform(_shimmerAnimation.value);

        return Text(
          'Authenticity Verified',
          style: TextStyle(
            fontFamily: 'EBGaramond',
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}

// Custom painter to draw X icon
class CrossPainter extends CustomPainter {
  final Color color;

  CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw first line (top-left to bottom-right)
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    // Draw second line (top-right to bottom-left)
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
