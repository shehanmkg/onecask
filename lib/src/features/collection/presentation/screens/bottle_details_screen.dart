import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

class _BottleDetailsScreenState extends State<BottleDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

                      // Bottle information container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        color: const Color(0xFF0A1F2E), // Slightly lighter blue with opacity
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bottle number
                            Text(
                              'Bottle 135/184',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFFE7E9EA),
                                fontSize: 14,
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
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  '18 Year old',
                                  style: const TextStyle(
                                    fontFamily: 'EBGaramond',
                                    color: Color(0xFFDE9A1F),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    height: 1.1,
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
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tabs
                            _buildTabBar(),

                            const SizedBox(height: 24),

                            // Tab content
                            _buildTabContent(),

                            const SizedBox(height: 40),

                            // Add to collection button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add, size: 24),
                                label: const Text(
                                  'Add to my collection',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDE9A1F),
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  // Add to collection logic
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
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
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1C21).withOpacity(0.8),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Genuine bottle icon
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1F2E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF1A2F3E),
                      width: 1,
                    ),
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

                // Dropdown arrow
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFFDE9A1F),
                  size: 28,
                ),
              ],
            ),

            // Expanded content
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1F2E).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authenticity Verified',
                      style: const TextStyle(
                        fontFamily: 'EBGaramond',
                        color: Color(0xFFE7E9EA),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1C21),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFDE9A1F),
          borderRadius: BorderRadius.circular(8),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: EdgeInsets.zero,
        labelColor: Colors.black87,
        unselectedLabelColor: const Color(0xFFABB2B9),
        labelStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.0,
        ),
        tabs: const [
          SizedBox(
            height: 52,
            child: Center(child: Text('Details')),
          ),
          SizedBox(
            height: 52,
            child: Center(child: Text('Tasting notes')),
          ),
          SizedBox(
            height: 52,
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'No tasting notes available yet.',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xFFE7E9EA),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      case 2: // History tab
        return _buildHistoryTimeline();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHistoryTimeline() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
          _buildTimelineTile(
            isFirst: true,
            isLast: false,
            label: 'Label',
            title: 'Title',
            description: 'Description\nDescription',
            hasAttachments: true,
          ),
          _buildTimelineDot(),
          _buildTimelineTile(
            isFirst: false,
            isLast: true,
            label: 'Label',
            title: 'Title',
            description: 'Description\nDescription',
            hasAttachments: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15.5),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFDE9A1F),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required String label,
    required String title,
    required String description,
    required bool hasAttachments,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.12,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 32,
        height: 32,
        indicator: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE7E9EA),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE7E9EA),
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.all(0),
      ),
      beforeLineStyle: const LineStyle(
        color: Color(0xFFDE9A1F),
        thickness: 2,
      ),
      afterLineStyle: const LineStyle(
        color: Color(0xFFDE9A1F),
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 0, top: 8, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFD7D5D1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'EBGaramond',
                color: Color(0xFFE7E9EA),
                fontSize: 24,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                fontSize: 16,
                height: 1.4,
              ),
            ),

            // Attachments section
            if (hasAttachments) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1C21),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Attachment header with icon
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_file_outlined,
                          color: Color(0xFFE7E9EA),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Attachments',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFE7E9EA),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attachment preview grid
                    Row(
                      children: [
                        _buildAttachmentPreview(),
                        const SizedBox(width: 8),
                        _buildAttachmentPreview(),
                        const SizedBox(width: 8),
                        _buildAttachmentPreview(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      startChild: isLast
          ? Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: _buildTimelineDiamond(),
            )
          : null,
    );
  }

  Widget _buildTimelineDiamond() {
    return Container(
      alignment: const Alignment(0.0, -0.2),
      child: Transform.rotate(
        angle: 0.785398, // 45 degrees in radians
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFFDE9A1F),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
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
              color: Color(0xFFE7E9EA),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xFFD7D5D1),
              fontSize: 16,
            ),
          ),
        ],
      ),
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
