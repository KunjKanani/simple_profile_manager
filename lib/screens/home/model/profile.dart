class ProfileData {
  List<ProfileModel> profiles;

  ProfileData({
    required this.profiles,
  });

  ProfileData.fromJson(Map<String, dynamic> json)
      : profiles = List<ProfileModel>.from(
          json['profiles']?.map(
                (profile) => ProfileModel.fromJson(profile),
              ) ??
              [],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profiles'] = profiles.map((profile) => profile.toJson()).toList();
    return data;
  }
}

class ProfileModel {
  double? lat;
  double? long;
  String? name;
  String? theme;
  String? fontSize;

  ProfileModel({
    this.lat,
    this.long,
    this.name,
    this.theme,
    this.fontSize,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    name = json['name'];
    theme = json['theme'];
    fontSize = json['fontSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    data['name'] = name;
    data['theme'] = theme;
    data['fontSize'] = fontSize;
    return data;
  }

  @override
  String toString() {
    return 'ProfileModel(lat: $lat, long: $long, name: $name, theme: $theme, fontSize: $fontSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.lat == lat &&
        other.long == long &&
        other.name == name &&
        other.theme == theme &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    return lat.hashCode ^
        long.hashCode ^
        name.hashCode ^
        theme.hashCode ^
        fontSize.hashCode;
  }
}
