import 'package:flutter/material.dart';

import '../../../../models/whiskey.dart';

class BottleInfoWidget extends StatelessWidget {
  final Whiskey whiskey;
  final String bottleYear;
  final String edition;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const BottleInfoWidget({
    Key? key,
    required this.whiskey,
    required this.bottleYear,
    required this.edition,
    required this.fadeAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
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
                Hero(
                  tag: 'distillery_${whiskey.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      whiskey.distillery,
                      style: const TextStyle(
                        fontFamily: 'EBGaramond',
                        color: Color(0xFFE7E9EA),
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'year_${whiskey.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      bottleYear,
                      style: const TextStyle(
                        fontFamily: 'EBGaramond',
                        color: Color(0xFFE7E9EA),
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Hero(
                  tag: 'edition_${whiskey.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      edition,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xFFD7D5D1),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
