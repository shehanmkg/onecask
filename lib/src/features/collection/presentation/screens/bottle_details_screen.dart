import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/whiskey.dart';
import '../../bloc/collection_bloc.dart';
import '../widgets/bottle_info_widget.dart';
import '../widgets/whiskey_detail_tabs_widget.dart';

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
  bool _isExpanded = false;

  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _contentAnimationController;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

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

    // Initialize content animation controller
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
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

    // Start content animation after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    _contentAnimationController.dispose();
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

          // Create page transition animation variables
          final String bottleYear = "${whiskey.bottled} #${whiskey.id.split('_').last}";
          final String edition = _generateEditionNumber(whiskey.id);

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
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _buildTopBar(),
                    ),
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: SlideTransition(
                        position: _contentSlideAnimation,
                        child: _buildAuthenticitySection(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.4,
                              child: Center(
                                child: Hero(
                                  tag: 'bottle_${whiskey.id}',
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
                                  // Using the custom bottle info widget
                                  BottleInfoWidget(
                                    whiskey: whiskey,
                                    bottleYear: bottleYear,
                                    edition: edition,
                                    fadeAnimation: _contentFadeAnimation,
                                    slideAnimation: _contentSlideAnimation,
                                  ),
                                  const SizedBox(height: 24),
                                  // Using the custom tabs widget
                                  FadeTransition(
                                    opacity: _contentFadeAnimation,
                                    child: SlideTransition(
                                      position: _contentSlideAnimation,
                                      child: WhiskeyDetailTabsWidget(
                                        whiskey: whiskey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Add to collection button
                            FadeTransition(
                              opacity: _contentFadeAnimation,
                              child: SlideTransition(
                                position: _contentSlideAnimation,
                                child: Container(
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
        splashColor: const Color(0xFFDE9A1F).withOpacity(0.1),
        highlightColor: const Color(0xFFDE9A1F).withOpacity(0.05),
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
                              color: Colors.black.withOpacity(0.2),
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
