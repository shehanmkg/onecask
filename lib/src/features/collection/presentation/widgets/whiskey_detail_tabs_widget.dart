import 'package:flutter/material.dart';

import '../../../../models/whiskey.dart';
import 'tasting_notes_widget.dart';

class WhiskeyDetailTabsWidget extends StatefulWidget {
  final Whiskey whiskey;

  const WhiskeyDetailTabsWidget({
    Key? key,
    required this.whiskey,
  }) : super(key: key);

  @override
  State<WhiskeyDetailTabsWidget> createState() => _WhiskeyDetailTabsWidgetState();
}

class _WhiskeyDetailTabsWidgetState extends State<WhiskeyDetailTabsWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        const SizedBox(height: 24),
        _buildTabContent(),
      ],
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
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTabContent() {
    final whiskey = widget.whiskey;

    switch (_tabController.index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Distillery', whiskey.distillery),
            _buildDetailRow('Region', whiskey.region),
            _buildDetailRow('Country', whiskey.region.split(',').last.trim()),
            _buildDetailRow('Type', 'Single Malt'),
            _buildDetailRow('Age statement', '${whiskey.age} years'),
            _buildDetailRow('Filled', ''),
            _buildDetailRow('Bottled', whiskey.bottled),
            _buildDetailRow('Cask number', '#${whiskey.id.split('_').last}'),
            _buildDetailRow('ABV', '${whiskey.abv}%'),
            _buildDetailRow('Size', '750ml'),
            _buildDetailRow('Finish', whiskey.caskType),
          ],
        );
      case 1:
        return TastingNotesWidget(whiskey: whiskey);
      case 2:
        return _buildHistoryTimeline();
      default:
        return const SizedBox.shrink();
    }
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

  Widget _buildHistoryTimeline() {
    return Stack(
      children: [
        Positioned(
          left: 11.5,
          top: 12,
          bottom: 12,
          width: 2,
          child: Container(
            color: const Color(0xFFD49A00),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _buildTimelineEntry('Label', 'Title'),
              const SizedBox(height: 30),
              _buildTimelineDiamond(6),
              const SizedBox(height: 30),
              _buildTimelineDiamond(10),
              const SizedBox(height: 30),
              _buildTimelineDiamond(6),
              const SizedBox(height: 30),
              _buildTimelineEntry('Label', 'Title'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineEntry(String label, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xFFB8BDBF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
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
    );
  }

  Widget _buildTimelineDiamond(double size) {
    final padding = (12 - size) / 2;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 9.0 + padding),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: size,
              height: size,
              color: const Color(0xFFD49A00),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
}
