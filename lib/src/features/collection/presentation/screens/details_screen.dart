import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/whiskey.dart';
import '../../bloc/collection_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String itemId;

  const DetailsScreen({super.key, required this.itemId});

  static const String routeName = '/details';

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
      ),
      body: BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
          if (state is CollectionLoaded) {
            Whiskey? whiskey;
            for (final currentItem in state.whiskeys) {
              if (currentItem.id == itemId) {
                whiskey = currentItem;
                break;
              }
            }

            if (whiskey == null) {
              return const Center(
                child: Text('Item not found.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (whiskey.imageUrl.isNotEmpty)
                    Center(
                      child: Image.asset(
                        whiskey.imageUrl,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 200),
                      ),
                    )
                  else
                    const Center(child: Icon(Icons.image_not_supported, size: 200)),
                  const SizedBox(height: 24),

                  Text(
                    whiskey.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),

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
            return const Center(child: Text('Loading item details...'));
          }
        },
      ),
    );
  }
}
