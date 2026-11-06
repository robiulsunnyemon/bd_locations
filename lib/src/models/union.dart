/// Represents an administrative Union Parishad (ইউনিয়ন পরিষদ) of Bangladesh.
class Union {
  /// Unique identifier of the union.
  final int id;

  /// Identifier of the parent [Upazila] this union belongs to.
  final int upazilaId;

  /// English name of the union.
  final String nameEn;

  /// Bengali name of the union.
  final String nameBn;

  /// Official government web portal URL of the union.
  final String? url;

  /// Creates an immutable [Union] instance.
  const Union({
    required this.id,
    required this.upazilaId,
    required this.nameEn,
    required this.nameBn,
    this.url,
  });

  /// Creates a [Union] from a JSON map.
  factory Union.fromJson(Map<String, dynamic> json) {
    return Union(
      id: json['id'] as int,
      upazilaId: json['upazila_id'] as int,
      nameEn: json['name_en'] as String,
      nameBn: json['name_bn'] as String,
      url: json['url'] as String?,
    );
  }

  /// Converts this [Union] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'upazila_id': upazilaId,
      'name_en': nameEn,
      'name_bn': nameBn,
      if (url != null) 'url': url,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Union &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          upazilaId == other.upazilaId &&
          nameEn == other.nameEn &&
          nameBn == other.nameBn;

  @override
  int get hashCode => Object.hash(id, upazilaId, nameEn, nameBn);

  @override
  String toString() =>
      'Union(id: $id, upazilaId: $upazilaId, nameEn: $nameEn, nameBn: $nameBn)';
}
