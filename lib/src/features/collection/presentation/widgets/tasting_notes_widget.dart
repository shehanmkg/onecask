import 'package:flutter/material.dart';

import '../../../../models/whiskey.dart';

class TastingNotesWidget extends StatelessWidget {
  final Whiskey whiskey;

  const TastingNotesWidget({
    Key? key,
    required this.whiskey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
