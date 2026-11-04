/// Represents an administrative District (জেলা) of Bangladesh.
class District {
  /// Unique identifier of the district (1 to 64).
  final int id;

  /// Identifier of the parent [Division] this district belongs to.
  final int divisionId;

  /// English name of the district (e.g., 'Dhaka', 'Sylhet').
  final String nameEn;

  /// Bengali name of the district (e.g., 'ঢাকা', 'সিলেট').
  final String nameBn;

  /// Approximate latitude of the district center.
  final double lat;

  /// Approximate longitude of the district center.
  final double lng;

  /// Official government web portal URL of the district.
  final String? url;

  /// Creates an immutable [District] instance.
  const District({
    required this.id,
    required this.divisionId,
    required this.nameEn,
    required this.nameBn,
    required this.lat,
    required this.lng,
    this.url,
  });

  /// Creates a [District] from a JSON map.
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] as int,
      divisionId: json['division_id'] as int,
      nameEn: json['name_en'] as String,
      nameBn: json['name_bn'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      url: json['url'] as String?,
    );
  }

  /// Converts this [District] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'division_id': divisionId,
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
      other is District &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          divisionId == other.divisionId &&
          nameEn == other.nameEn &&
          nameBn == other.nameBn;

  @override
  int get hashCode => Object.hash(id, divisionId, nameEn, nameBn);

  @override
  String toString() =>
      'District(id: $id, divisionId: $divisionId, nameEn: $nameEn, nameBn: $nameBn)';
}
