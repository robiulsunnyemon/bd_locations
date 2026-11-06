import 'dart:math' as math;

import 'data/districts_data.dart';
import 'data/divisions_data.dart';
import 'data/postcodes_data.dart';
import 'data/unions_data.dart';
import 'data/upazilas_data.dart';
import 'models/district.dart';
import 'models/division.dart';
import 'models/post_office.dart';
import 'models/union.dart';
import 'models/upazila.dart';

/// Main entry point for accessing Bangladesh geographic data (Divisions,
/// Districts, Upazilas, Unions, and Post Offices) along with bilingual search
/// and geolocation helpers.
class BdLocations {
  // Private constructor to prevent instantiation.
  const BdLocations._();

  /// Map of common legacy/alternative English spellings to official spellings.
  static const Map<String, String> _spellingAliases = {
    'chittagong': 'chattogram',
    'chattagram': 'chattogram',
    'comilla': 'cumilla',
    'bogra': 'bogura',
    'jessore': 'jashore',
    'barisal': 'barishal',
    'chapai nawabganj': 'chapainawabganj',
    'chapinawabganj': 'chapainawabganj',
    'nawabganj': 'chapainawabganj',
    'coxs bazar': "cox's bazar",
    'coxsbazar': "cox's bazar",
    'jhalokati': 'jhalakathi',
    'jhalokathi': 'jhalakathi',
    'netrakona': 'netrokona',
    'brahmanbaria': 'brahmanbaria',
    'bbaria': 'brahmanbaria',
    'khagrachari': 'khagrachhari',
    'laxmipur': 'lakshmipur',
    'laksmipur': 'lakshmipur',
    'maulvibazar': 'moulvibazar',
    'habigonj': 'habiganj',
    'sunamgonj': 'sunamganj',
    'sirajgonj': 'sirajganj',
    'narayangonj': 'narayanganj',
    'manikgonj': 'manikganj',
    'munshigonj': 'munshiganj',
    'gopalgonj': 'gopalganj',
    'kishoregonj': 'kishoreganj',
  };

  /// Returns all 8 administrative divisions of Bangladesh.
  static List<Division> get divisions => kDivisions;

  /// Returns all 64 administrative districts of Bangladesh.
  static List<District> get districts => kDistricts;

  /// Returns all 495 administrative upazilas of Bangladesh.
  static List<Upazila> get upazilas => kUpazilas;

  /// Returns all 4,540 administrative unions of Bangladesh.
  static List<Union> get unions => kUnions;

  /// Returns all 1,349 post offices and postal codes of Bangladesh.
  static List<PostOffice> get postOffices => kPostOffices;

  /// Finds a [Division] by its unique [id] (1 to 8).
  ///
  /// Returns `null` if no division matches the given [id].
  static Division? getDivisionById(int id) {
    for (final division in kDivisions) {
      if (division.id == id) return division;
    }
    return null;
  }

  /// Finds a [District] by its unique [id] (1 to 64).
  ///
  /// Returns `null` if no district matches the given [id].
  static District? getDistrictById(int id) {
    for (final district in kDistricts) {
      if (district.id == id) return district;
    }
    return null;
  }

  /// Finds an [Upazila] by its unique [id] (1 to 495).
  ///
  /// Returns `null` if no upazila matches the given [id].
  static Upazila? getUpazilaById(int id) {
    for (final upazila in kUpazilas) {
      if (upazila.id == id) return upazila;
    }
    return null;
  }

  /// Finds a [Union] by its unique [id].
  ///
  /// Returns `null` if no union matches the given [id].
  static Union? getUnionById(int id) {
    for (final union in kUnions) {
      if (union.id == id) return union;
    }
    return null;
  }

  /// Returns all [District]s belonging to the specified [divisionId].
  static List<District> getDistrictsByDivision(int divisionId) {
    return kDistricts
        .where((district) => district.divisionId == divisionId)
        .toList(growable: false);
  }

  /// Returns all [Upazila]s belonging to the specified [districtId].
  static List<Upazila> getUpazilasByDistrict(int districtId) {
    return kUpazilas
        .where((upazila) => upazila.districtId == districtId)
        .toList(growable: false);
  }

  /// Returns all [Upazila]s belonging to the specified [divisionId].
  static List<Upazila> getUpazilasByDivision(int divisionId) {
    final districtIds = getDistrictsByDivision(divisionId)
        .map((district) => district.id)
        .toSet();
    return kUpazilas
        .where((upazila) => districtIds.contains(upazila.districtId))
        .toList(growable: false);
  }

  /// Returns all [Union]s belonging to the specified [upazilaId].
  static List<Union> getUnionsByUpazila(int upazilaId) {
    return kUnions
        .where((union) => union.upazilaId == upazilaId)
        .toList(growable: false);
  }

  /// Returns all [Union]s belonging to the specified [districtId].
  static List<Union> getUnionsByDistrict(int districtId) {
    final upazilaIds =
        getUpazilasByDistrict(districtId).map((upazila) => upazila.id).toSet();
    return kUnions
        .where((union) => upazilaIds.contains(union.upazilaId))
        .toList(growable: false);
  }

  /// Returns all [PostOffice]s belonging to the specified [districtId].
  static List<PostOffice> getPostOfficesByDistrict(int districtId) {
    return kPostOffices
        .where((po) => po.districtId == districtId)
        .toList(growable: false);
  }

  /// Returns all [PostOffice]s belonging to the specified [divisionId].
  static List<PostOffice> getPostOfficesByDivision(int divisionId) {
    return kPostOffices
        .where((po) => po.divisionId == divisionId)
        .toList(growable: false);
  }

  /// Finds all [PostOffice]s matching the given 4-digit [postcode]
  /// (supports both English `'1207'` and Bengali `'১২০৭'` digits).
  static List<PostOffice> findByPostcode(String postcode) {
    final trimmed = postcode.trim();
    if (trimmed.isEmpty) return const [];
    return kPostOffices
        .where((po) => po.postcode == trimmed || po.postcodeBn == trimmed)
        .toList(growable: false);
  }

  /// Checks whether the given [postcode] (in English or Bengali digits) is a
  /// valid postal code in Bangladesh.
  static bool isValidPostcode(String postcode) {
    final trimmed = postcode.trim();
    if (trimmed.isEmpty) return false;
    return kPostOffices.any(
      (po) => po.postcode == trimmed || po.postcodeBn == trimmed,
    );
  }

  /// Searches [Division]s by Bengali or English name (supports legacy spellings
  /// like 'Chittagong' or 'Barisal').
  static List<Division> searchDivisions(String query) {
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return kDivisions;

    return kDivisions.where((division) {
      return _matches(
        query: normalized,
        nameEn: division.nameEn,
        nameBn: division.nameBn,
      );
    }).toList(growable: false);
  }

  /// Searches [District]s by Bengali or English name (supports legacy spellings
  /// like 'Jessore', 'Comilla', 'Bogra', 'Chittagong', etc.).
  ///
  /// Optionally filter by [divisionId].
  static List<District> searchDistricts(String query, {int? divisionId}) {
    final source =
        divisionId != null ? getDistrictsByDivision(divisionId) : kDistricts;
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return source;

    return source.where((district) {
      return _matches(
        query: normalized,
        nameEn: district.nameEn,
        nameBn: district.nameBn,
      );
    }).toList(growable: false);
  }

  /// Searches [Upazila]s by Bengali or English name.
  ///
  /// Optionally filter by [districtId].
  static List<Upazila> searchUpazilas(String query, {int? districtId}) {
    final source =
        districtId != null ? getUpazilasByDistrict(districtId) : kUpazilas;
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return source;

    return source.where((upazila) {
      return _matches(
        query: normalized,
        nameEn: upazila.nameEn,
        nameBn: upazila.nameBn,
      );
    }).toList(growable: false);
  }

  /// Searches [Union]s by Bengali or English name.
  ///
  /// Optionally filter by [upazilaId].
  static List<Union> searchUnions(String query, {int? upazilaId}) {
    final source = upazilaId != null ? getUnionsByUpazila(upazilaId) : kUnions;
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return source;

    return source.where((union) {
      return _matches(
        query: normalized,
        nameEn: union.nameEn,
        nameBn: union.nameBn,
      );
    }).toList(growable: false);
  }

  /// Searches [PostOffice]s by postal code (English or Bengali digits),
  /// sub-office name, or upazila name.
  ///
  /// Optionally filter by [districtId].
  static List<PostOffice> searchPostOffices(String query, {int? districtId}) {
    final source = districtId != null
        ? getPostOfficesByDistrict(districtId)
        : kPostOffices;
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return source;

    return source.where((po) {
      return po.postcode.contains(trimmed) ||
          po.postcodeBn.contains(trimmed) ||
          po.subOfficeEn.toLowerCase().contains(trimmed) ||
          po.upazilaEn.toLowerCase().contains(trimmed) ||
          (po.subOfficeBn != null && po.subOfficeBn!.contains(trimmed));
    }).toList(growable: false);
  }

  /// Finds the nearest [District] to the given geographic coordinates
  /// ([lat], [lng]) using the Haversine great-circle distance formula.
  static District findNearestDistrict(double lat, double lng) {
    District nearest = kDistricts.first;
    double minDistance = double.infinity;

    for (final district in kDistricts) {
      final d = distanceInKm(lat, lng, district.lat, district.lng);
      if (d < minDistance) {
        minDistance = d;
        nearest = district;
      }
    }
    return nearest;
  }

  /// Finds the nearest [Division] to the given geographic coordinates
  /// ([lat], [lng]) using the Haversine great-circle distance formula.
  static Division findNearestDivision(double lat, double lng) {
    Division nearest = kDivisions.first;
    double minDistance = double.infinity;

    for (final division in kDivisions) {
      final d = distanceInKm(lat, lng, division.lat, division.lng);
      if (d < minDistance) {
        minDistance = d;
        nearest = division;
      }
    }
    return nearest;
  }

  /// Calculates the great-circle distance (in kilometers) between two
  /// geographic coordinates using the Haversine formula.
  static double distanceInKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLng = _degToRad(lng2 - lng1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);

  static String _normalizeQuery(String query) {
    final trimmed = query.trim().toLowerCase();
    return _spellingAliases[trimmed] ?? trimmed;
  }

  static bool _matches({
    required String query,
    required String nameEn,
    required String nameBn,
  }) {
    final lowerEn = nameEn.toLowerCase();
    final canonicalEn = _spellingAliases[lowerEn] ?? lowerEn;

    return lowerEn.contains(query) ||
        canonicalEn.contains(query) ||
        nameBn.contains(query);
  }
}
