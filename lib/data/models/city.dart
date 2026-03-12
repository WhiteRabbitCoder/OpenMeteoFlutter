class City {
  const City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.region,
  });

  final String name;
  final String country;
  final String? region;
  final double latitude;
  final double longitude;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      region: json['admin1'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String get fullName {
    final regionPart = (region == null || region!.isEmpty) ? '' : ', $region';
    return '$name$regionPart, $country';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is City &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            country == other.country &&
            region == other.region;
  }

  @override
  int get hashCode => Object.hash(name, country, region);
}
