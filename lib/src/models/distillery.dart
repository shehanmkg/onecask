import 'package:equatable/equatable.dart';

class Distillery extends Equatable {
  final String id;
  final String name;
  final String location;
  final int founded;
  final String description;
  final String owner;
  final String image;

  const Distillery({
    required this.id,
    required this.name,
    required this.location,
    required this.founded,
    required this.description,
    required this.owner,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, location, founded, description, owner, image];

  factory Distillery.fromJson(Map<String, dynamic> json) {
    return Distillery(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      founded: json['founded'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'founded': founded,
      'description': description,
      'owner': owner,
      'image': image,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory Distillery.fromMap(Map<String, dynamic> map) => Distillery.fromJson(map);
}
