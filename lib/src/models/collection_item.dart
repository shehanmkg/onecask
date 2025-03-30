import 'package:equatable/equatable.dart';

class CollectionItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  const CollectionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Unnamed Item',
      description: json['description'] as String? ?? 'No description available.',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
     return CollectionItem(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed Item',
      description: map['description'] as String? ?? 'No description available.',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}