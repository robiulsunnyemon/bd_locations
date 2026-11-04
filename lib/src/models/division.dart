/// Represents an administrative Division (বিভাগ) of Bangladesh.
class Division {
  /// Unique identifier of the division (1 to 8).
  final int id;

  /// English name of the division (e.g., 'Dhaka', 'Chattogram').
  final String nameEn;

  /// Bengali name of the division (e.g., 'ঢাকা', 'চট্টগ্রাম').
  final String nameBn;

  /// Approximate latitude of the division headquarters.
  final double lat;

  /// Approximate longitude of the division headquarters.
  final double lng;

  /// Official government web portal URL of the division.
  final String? url;

  /// Creates an immutable [Division] instance.
  const Division({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.lat,
    required this.lng,
    this.url,
  });

  /// Creates a [Division] from a JSON map.
  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'] as int,
      nameEn: json['name_en'] as String,
      nameBn: json['name_bn'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      url: json['url'] as String?,
    );
  }

  /// Converts this [Division] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_bn': nameBn,
      'lat': lat,
      'lng': lng,
      if (url != null) 'url': url,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Division &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameEn == other.nameEn &&
          nameBn == other.nameBn;

  @override
  int get hashCode => Object.hash(id, nameEn, nameBn);

  @override
  String toString() => 'Division(id: $id, nameEn: $nameEn, nameBn: $nameBn)';
}
