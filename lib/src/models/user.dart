import 'package:equatable/equatable.dart';

class UserPreferences {
  final List<String> favoriteRegions;
  final List<String> favoriteCaskTypes;
  final List<String> favoriteDistilleries;
  final String preferredAbv;
  final List<String> collectingGoals;

  UserPreferences({
    required this.favoriteRegions,
    required this.favoriteCaskTypes,
    required this.favoriteDistilleries,
    required this.preferredAbv,
    required this.collectingGoals,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteRegions: List<String>.from(json['favoriteRegions'] ?? []),
      favoriteCaskTypes: List<String>.from(json['favoriteCaskTypes'] ?? []),
      favoriteDistilleries: List<String>.from(json['favoriteDistilleries'] ?? []),
      preferredAbv: json['preferredAbv'] as String? ?? '',
      collectingGoals: List<String>.from(json['collectingGoals'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteRegions': favoriteRegions,
      'favoriteCaskTypes': favoriteCaskTypes,
      'favoriteDistilleries': favoriteDistilleries,
      'preferredAbv': preferredAbv,
      'collectingGoals': collectingGoals,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory UserPreferences.fromMap(Map<String, dynamic> map) => UserPreferences.fromJson(map);
}

class UserStats {
  final int bottlesOwned;
  final int bottlesTasted;
  final int reviewsWritten;
  final String favoriteDram;
  final String topRatedWhisky;

  UserStats({
    required this.bottlesOwned,
    required this.bottlesTasted,
    required this.reviewsWritten,
    required this.favoriteDram,
    required this.topRatedWhisky,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      bottlesOwned: json['bottlesOwned'] as int? ?? 0,
      bottlesTasted: json['bottlesTasted'] as int? ?? 0,
      reviewsWritten: json['reviewsWritten'] as int? ?? 0,
      favoriteDram: json['favoriteDram'] as String? ?? '',
      topRatedWhisky: json['topRatedWhisky'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bottlesOwned': bottlesOwned,
      'bottlesTasted': bottlesTasted,
      'reviewsWritten': reviewsWritten,
      'favoriteDram': favoriteDram,
      'topRatedWhisky': topRatedWhisky,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory UserStats.fromMap(Map<String, dynamic> map) => UserStats.fromJson(map);
}

class UserSettings {
  final String currency;
  final String unitSystem;
  final bool notifications;
  final String privacyLevel;

  UserSettings({
    required this.currency,
    required this.unitSystem,
    required this.notifications,
    required this.privacyLevel,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      currency: json['currency'] as String? ?? 'USD',
      unitSystem: json['unitSystem'] as String? ?? 'Metric',
      notifications: json['notifications'] as bool? ?? true,
      privacyLevel: json['privacyLevel'] as String? ?? 'Private',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'unitSystem': unitSystem,
      'notifications': notifications,
      'privacyLevel': privacyLevel,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory UserSettings.fromMap(Map<String, dynamic> map) => UserSettings.fromJson(map);
}

class User extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String joinDate;
  final String profileImage;
  final UserPreferences preferences;
  final UserStats stats;
  final UserSettings settings;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.joinDate,
    required this.profileImage,
    required this.preferences,
    required this.stats,
    required this.settings,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        displayName,
        email,
        joinDate,
        profileImage,
        preferences,
        stats,
        settings,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      joinDate: json['joinDate'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : UserPreferences(
              favoriteRegions: [],
              favoriteCaskTypes: [],
              favoriteDistilleries: [],
              preferredAbv: '',
              collectingGoals: [],
            ),
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : UserStats(
              bottlesOwned: 0,
              bottlesTasted: 0,
              reviewsWritten: 0,
              favoriteDram: '',
              topRatedWhisky: '',
            ),
      settings: json['settings'] != null
          ? UserSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : UserSettings(
              currency: 'USD',
              unitSystem: 'Metric',
              notifications: true,
              privacyLevel: 'Private',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'joinDate': joinDate,
      'profileImage': profileImage,
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'settings': settings.toJson(),
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory User.fromMap(Map<String, dynamic> map) => User.fromJson(map);
}
