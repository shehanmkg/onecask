import 'package:equatable/equatable.dart';

class CollectionItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // URL or asset path for the item image

  const CollectionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];

  // Factory constructor to create an instance from JSON
  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    // Basic validation/casting
    return CollectionItem(
      id: json['id']?.toString() ?? '', // Ensure ID is a string
      name: json['name'] as String? ?? 'Unnamed Item',
      description: json['description'] as String? ?? 'No description available.',
      imageUrl: json['imageUrl'] as String? ?? '', // Handle missing image URL
    );
  }

  // Method to convert instance to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

   // Factory constructor to create an instance from a database Map
  factory CollectionItem.fromMap(Map<String, dynamic> map) {
     return CollectionItem(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed Item',
      description: map['description'] as String? ?? 'No description available.',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}