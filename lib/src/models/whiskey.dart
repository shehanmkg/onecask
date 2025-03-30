import 'package:equatable/equatable.dart';

class TastingNotes {
  final String nose;
  final String palate;
  final String finish;

  TastingNotes({
    required this.nose,
    required this.palate,
    required this.finish,
  });

  factory TastingNotes.fromJson(Map<String, dynamic> json) {
    return TastingNotes(
      nose: json['nose'] as String? ?? '',
      palate: json['palate'] as String? ?? '',
      finish: json['finish'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nose': nose,
      'palate': palate,
      'finish': finish,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory TastingNotes.fromMap(Map<String, dynamic> map) => TastingNotes.fromJson(map);
}

class Whiskey extends Equatable {
  final String id;
  final String name;
  final String description;
  final String distillery;
  final String region;
  final int age;
  final double abv;
  final String caskType;
  final String bottled;
  final double price;
  final double rating;
  final TastingNotes tastingNotes;
  final bool limitedEdition;
  final bool inCollection;
  final String purchaseDate;
  final String imageUrl;

  const Whiskey({
    required this.id,
    required this.name,
    required this.description,
    required this.distillery,
    required this.region,
    required this.age,
    required this.abv,
    required this.caskType,
    required this.bottled,
    required this.price,
    required this.rating,
    required this.tastingNotes,
    required this.limitedEdition,
    required this.inCollection,
    required this.purchaseDate,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        distillery,
        region,
        age,
        abv,
        caskType,
        bottled,
        price,
        rating,
        tastingNotes,
        limitedEdition,
        inCollection,
        purchaseDate,
        imageUrl
      ];

  factory Whiskey.fromJson(Map<String, dynamic> json) {
    return Whiskey(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      distillery: json['distillery'] as String? ?? '',
      region: json['region'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      abv: (json['abv'] as num?)?.toDouble() ?? 0.0,
      caskType: json['caskType'] as String? ?? '',
      bottled: json['bottled'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      tastingNotes: json['tasting_notes'] != null
          ? TastingNotes.fromJson(json['tasting_notes'] as Map<String, dynamic>)
          : TastingNotes(nose: '', palate: '', finish: ''),
      limitedEdition: json['limited_edition'] as bool? ?? false,
      inCollection: json['in_collection'] as bool? ?? false,
      purchaseDate: json['purchase_date'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'distillery': distillery,
      'region': region,
      'age': age,
      'abv': abv,
      'caskType': caskType,
      'bottled': bottled,
      'price': price,
      'rating': rating,
      'tasting_notes': tastingNotes.toJson(),
      'limited_edition': limitedEdition,
      'in_collection': inCollection,
      'purchase_date': purchaseDate,
      'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory Whiskey.fromMap(Map<String, dynamic> map) => Whiskey.fromJson(map);
}
