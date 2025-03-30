import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/whiskey.dart'; // Import Whiskey model
import '../../bloc/collection_bloc.dart'; // Import CollectionBloc

class DetailsScreen extends StatelessWidget {
  final String itemId;

  const DetailsScreen({super.key, required this.itemId});

  // Define route name for potential use with go_router (though accessed via nested route)
  static const String routeName = '/details'; // Base name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'One Cask Detail',
          style: const TextStyle(
            fontFamily: 'EBGaramond',
            color: Color(0xFFE7E9EA),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Back button is automatically added by Navigator/GoRouter
      ),
      body: BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
          if (state is CollectionLoaded) {
            // Find the item in the loaded list using iteration
            Whiskey? whiskey;
            for (final currentItem in state.whiskeys) {
              if (currentItem.id == itemId) {
                whiskey = currentItem;
                break; // Found the item, exit loop
              }
            }

            if (whiskey == null) {
              return const Center(
                child: Text('Item not found.'),
              );
            }

            // Display item details
            return SingleChildScrollView(
              // Allow scrolling for long descriptions
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Image
                  if (whiskey.imageUrl.isNotEmpty)
                    Center(
                      child: Image.asset(
                        whiskey.imageUrl,
                        height: 200, // Adjust height as needed
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 200), // Placeholder on error
                      ),
                    )
                  else
                    const Center(child: Icon(Icons.image_not_supported, size: 200)), // Placeholder if no URL
                  const SizedBox(height: 24),

                  // Item Name
                  Text(
                    whiskey.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Item Description
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    whiskey.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Distillery & Region
                  Text(
                    'Distillery: ${whiskey.distillery}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Region: ${whiskey.region}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Age: ${whiskey.age} years',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'ABV: ${whiskey.abv}%',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Tasting Notes
                  Text(
                    'Tasting Notes:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nose: ${whiskey.tastingNotes.nose}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Palate: ${whiskey.tastingNotes.palate}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Finish: ${whiskey.tastingNotes.finish}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Item ID (for reference)
                  Text(
                    'ID: ${whiskey.id}',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xFFABB2B9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CollectionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CollectionError) {
            return Center(child: Text('Error loading collection: ${state.message}'));
          } else {
            // Should not happen if navigated from CollectionLoaded state
            return const Center(child: Text('Loading item details...'));
          }
        },
      ),
    );
  }
}
