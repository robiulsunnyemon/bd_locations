/// Represents an administrative Upazila (উপজেলা) or Thana of Bangladesh.
class Upazila {
  /// Unique identifier of the upazila.
  final int id;

  /// Identifier of the parent [District] this upazila belongs to.
  final int districtId;

  /// English name of the upazila (e.g., 'Savar', 'Hathazari').
  final String nameEn;

  /// Bengali name of the upazila (e.g., 'সাভার', 'হাটহাজারী').
  final String nameBn;

  /// Official government web portal URL of the upazila.
  final String? url;

  /// Creates an immutable [Upazila] instance.
  const Upazila({
    required this.id,
    required this.districtId,
    required this.nameEn,
    required this.nameBn,
    this.url,
  });

  /// Creates an [Upazila] from a JSON map.
  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['id'] as int,
      districtId: json['district_id'] as int,
      nameEn: json['name_en'] as String,
      nameBn: json['name_bn'] as String,
      url: json['url'] as String?,
    );
  }

  /// Converts this [Upazila] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district_id': districtId,
      'name_en': nameEn,
      'name_bn': nameBn,
      if (url != null) 'url': url,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Upazila &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          districtId == other.districtId &&
          nameEn == other.nameEn &&
          nameBn == other.nameBn;

  @override
  int get hashCode => Object.hash(id, districtId, nameEn, nameBn);

  @override
  String toString() =>
      'Upazila(id: $id, districtId: $districtId, nameEn: $nameEn, nameBn: $nameBn)';
}
