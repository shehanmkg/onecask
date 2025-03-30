import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/whiskey.dart';
import '../../bloc/collection_bloc.dart';

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

  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

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

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_shimmerController);

    if (_isExpanded) {
      _expandController.value = 1.0;
    }

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

    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        if (state is CollectionLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B1519),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFDE9A1F),
              ),
            ),
          );
        }

        if (state is CollectionError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0B1519),
            body: Center(
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
            ),
          );
        }

        if (state is CollectionLoaded) {
          Whiskey? whiskey;
          for (final item in state.whiskeys) {
            if (item.id == widget.bottleId) {
              whiskey = item;
              break;
            }
          }

          if (whiskey == null) {
            return Scaffold(
              backgroundColor: const Color(0xFF0B1519),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Whiskey not found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE9A1F),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFF0B1519),
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
                    _buildTopBar(),
                    _buildAuthenticitySection(),
                    const SizedBox(height: 25),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(24),
                              color: const Color(0xFF122329),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    whiskey.limitedEdition ? 'Limited Edition' : 'Standard Release',
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      color: Color(0xFFB8BDBF),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        whiskey.distillery,
                                        style: const TextStyle(
                                          fontFamily: 'EBGaramond',
                                          color: Color(0xFFE7E9EA),
                                          fontSize: 42,
                                          fontWeight: FontWeight.w500,
                                          height: 1.1,
                                        ),
                                      ),
                                      Text(
                                        '${whiskey.bottled} #${whiskey.id.split('_').last}',
                                        style: const TextStyle(
                                          fontFamily: 'EBGaramond',
                                          color: Color(0xFFE7E9EA),
                                          fontSize: 42,
                                          fontWeight: FontWeight.w500,
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _generateEditionNumber(whiskey.id),
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xFFD7D5D1),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildTabBar(whiskey),
                                  const SizedBox(height: 24),
                                  _buildTabContent(whiskey),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
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
                                label: Text(
                                  whiskey.inCollection ? 'Already in collection' : 'Add to my collection',
                                  style: const TextStyle(
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
                                  shadowColor: const Color(0xFF0B1519).withOpacity(0.3),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: whiskey.inCollection ? null : () {},
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

        return const Scaffold(
          backgroundColor: Color(0xFF0B1519),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFDE9A1F),
            ),
          ),
        );
      },
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

  Widget _buildTabBar(Whiskey whiskey) {
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

  Widget _buildTabContent(Whiskey whiskey) {
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
        return _buildTastingNotesContent(whiskey);
      case 2:
        return _buildHistoryTimeline();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTastingNotesContent(Whiskey whiskey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF0A1519),
              ),
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
        _buildTastingNotesSection(
          title: 'Nose',
          descriptions: [whiskey.tastingNotes.nose],
        ),
        const SizedBox(height: 24),
        _buildTastingNotesSection(
          title: 'Palate',
          descriptions: [whiskey.tastingNotes.palate],
        ),
        const SizedBox(height: 24),
        _buildTastingNotesSection(
          title: 'Finish',
          descriptions: [whiskey.tastingNotes.finish],
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
                  padding: const EdgeInsets.only(bottom: 6),
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
              Row(
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
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Transform.rotate(
                      angle: 0.785398,
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
                      angle: 0.785398,
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
                      angle: 0.785398,
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

  Widget _buildShimmerTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
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

  String _generateEditionNumber(String id) {
    try {
      final parts = id.split('_');
      if (parts.length == 2) {
        final number = int.parse(parts.last);
        final editionNumber = '(${(number % 100 + 12)}/${(number % 80 + 100)})';
        return editionNumber;
      }
    } catch (e) {}
    return '';
  }
}

class CrossPainter extends CustomPainter {
  final Color color;

  CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
