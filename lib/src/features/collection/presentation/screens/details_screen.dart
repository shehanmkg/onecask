import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/collection_item.dart'; // Import model
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
            CollectionItem? item;
            for (final currentItem in state.items) {
              if (currentItem.id == itemId) {
                item = currentItem;
                break; // Found the item, exit loop
              }
            }

            if (item == null) {
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
                  if (item.imageUrl.isNotEmpty)
                    Center(
                      child: Image.network(
                        item.imageUrl,
                        height: 200, // Adjust height as needed
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 200), // Placeholder on error
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                        },
                      ),
                    )
                  else
                    const Center(child: Icon(Icons.image_not_supported, size: 200)), // Placeholder if no URL
                  const SizedBox(height: 24),

                  // Item Name
                  Text(
                    item.name,
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
                    item.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Item ID (for reference)
                  Text(
                    'ID: ${item.id}',
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
