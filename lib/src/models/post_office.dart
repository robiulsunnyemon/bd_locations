/// Represents a Post Office and its 4-digit Postal Code (পোস্ট কোড) in Bangladesh.
class PostOffice {
  /// 4-digit postal code in English digits (e.g., `'1207'`).
  final String postcode;

  /// 4-digit postal code in Bengali digits (e.g., `'১২০৭'`).
  final String postcodeBn;

  /// Identifier of the parent [Division].
  final int divisionId;

  /// Identifier of the parent [District].
  final int districtId;

  /// English name of the Thana / Upazila for this post office.
  final String upazilaEn;

  /// English name of the sub-post office / area (e.g., `'Mohammadpur Housing'`).
  final String subOfficeEn;

  /// Optional Bengali name of the sub-post office / area.
  final String? subOfficeBn;

  /// Creates an immutable [PostOffice] instance.
  const PostOffice({
    required this.postcode,
    required this.postcodeBn,
    required this.divisionId,
    required this.districtId,
    required this.upazilaEn,
    required this.subOfficeEn,
    this.subOfficeBn,
  });

  /// Creates a [PostOffice] from a JSON map.
  factory PostOffice.fromJson(Map<String, dynamic> json) {
    return PostOffice(
      postcode: json['postcode'] as String,
      postcodeBn: json['postcode_bn'] as String,
      divisionId: json['division_id'] as int,
      districtId: json['district_id'] as int,
      upazilaEn: json['upazila_en'] as String,
      subOfficeEn: json['sub_office_en'] as String,
      subOfficeBn: json['sub_office_bn'] as String?,
    );
  }

  /// Converts this [PostOffice] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'postcode': postcode,
      'postcode_bn': postcodeBn,
      'division_id': divisionId,
      'district_id': districtId,
      'upazila_en': upazilaEn,
      'sub_office_en': subOfficeEn,
      if (subOfficeBn != null) 'sub_office_bn': subOfficeBn,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostOffice &&
          runtimeType == other.runtimeType &&
          postcode == other.postcode &&
          districtId == other.districtId &&
          subOfficeEn == other.subOfficeEn;

  @override
  int get hashCode => Object.hash(postcode, districtId, subOfficeEn);

  @override
  String toString() =>
      'PostOffice(postcode: $postcode ($postcodeBn), subOfficeEn: $subOfficeEn, upazilaEn: $upazilaEn)';
}
