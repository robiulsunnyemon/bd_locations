import 'bd_locations_base.dart';
import 'models/district.dart';
import 'models/division.dart';
import 'models/post_office.dart';
import 'models/union.dart';
import 'models/upazila.dart';

/// Convenience relational getters on [Division].
extension DivisionRelationExtension on Division {
  /// Returns all [District]s under this division.
  List<District> get districts => BdLocations.getDistrictsByDivision(id);

  /// Returns all [Upazila]s under this division.
  List<Upazila> get upazilas => BdLocations.getUpazilasByDivision(id);

  /// Returns all [PostOffice]s under this division.
  List<PostOffice> get postOffices => BdLocations.getPostOfficesByDivision(id);
}

/// Convenience relational getters on [District].
extension DistrictRelationExtension on District {
  /// Returns the parent [Division] of this district.
  Division get division => BdLocations.getDivisionById(divisionId)!;

  /// Returns all [Upazila]s under this district.
  List<Upazila> get upazilas => BdLocations.getUpazilasByDistrict(id);

  /// Returns all [Union]s under this district.
  List<Union> get unions => BdLocations.getUnionsByDistrict(id);

  /// Returns all [PostOffice]s under this district.
  List<PostOffice> get postOffices => BdLocations.getPostOfficesByDistrict(id);

  /// Formats the full address of this district (e.g., `'Dhaka, Dhaka Division'`
  /// or `'ঢাকা, ঢাকা বিভাগ'`).
  String formatAddress({bool inBangla = false}) {
    return inBangla
        ? '$nameBn, ${division.nameBn} বিভাগ'
        : '$nameEn, ${division.nameEn} Division';
  }
}

/// Convenience relational getters on [Upazila].
extension UpazilaRelationExtension on Upazila {
  /// Returns the parent [District] of this upazila.
  District get district => BdLocations.getDistrictById(districtId)!;

  /// Returns the parent [Division] of this upazila.
  Division get division => district.division;

  /// Returns all [Union]s under this upazila.
  List<Union> get unions => BdLocations.getUnionsByUpazila(id);

  /// Formats the full address of this upazila (e.g., `'Savar, Dhaka, Dhaka Division'`
  /// or `'সাভার, ঢাকা, ঢাকা বিভাগ'`).
  String formatAddress({bool inBangla = false}) {
    return inBangla
        ? '$nameBn, ${district.nameBn}, ${division.nameBn} বিভাগ'
        : '$nameEn, ${district.nameEn}, ${division.nameEn} Division';
  }
}

/// Convenience relational getters on [Union].
extension UnionRelationExtension on Union {
  /// Returns the parent [Upazila] of this union.
  Upazila get upazila => BdLocations.getUpazilaById(upazilaId)!;

  /// Returns the parent [District] of this union.
  District get district => upazila.district;

  /// Returns the parent [Division] of this union.
  Division get division => district.division;

  /// Formats the full address of this union (e.g.,
  /// `'Tetuljhora, Savar, Dhaka'` or `'তেঁতুলঝোড়া, সাভার, ঢাকা'`).
  String formatAddress({bool inBangla = false}) {
    return inBangla
        ? '$nameBn, ${upazila.nameBn}, ${district.nameBn}'
        : '$nameEn, ${upazila.nameEn}, ${district.nameEn}';
  }
}

/// Convenience relational getters on [PostOffice].
extension PostOfficeRelationExtension on PostOffice {
  /// Returns the parent [District] of this post office.
  District get district => BdLocations.getDistrictById(districtId)!;

  /// Returns the parent [Division] of this post office.
  Division get division => BdLocations.getDivisionById(divisionId)!;

  /// Formats the full postal address (e.g.,
  /// `'Mohammadpur Housing (1207), Dhaka'` or `'Mohammadpur Housing (১২০৭), ঢাকা'`).
  String formatAddress({bool inBangla = false}) {
    if (inBangla) {
      final office = subOfficeBn ?? subOfficeEn;
      return '$office ($postcodeBn), ${district.nameBn}';
    }
    return '$subOfficeEn ($postcode), $upazilaEn, ${district.nameEn}';
  }
}
