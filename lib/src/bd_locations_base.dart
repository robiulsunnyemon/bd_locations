import 'dart:math' as math;

import 'data/districts_data.dart';
import 'data/divisions_data.dart';
import 'data/upazilas_data.dart';
import 'models/district.dart';
import 'models/division.dart';
import 'models/upazila.dart';

/// Main entry point for accessing Bangladesh geographic data (Divisions,
/// Districts, and Upazilas) along with bilingual search and geolocation helpers.
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
    'nawabganj': 'chapainawabganj',
    'coxs bazar': "cox's bazar",
    'coxsbazar': "cox's bazar",
    'jhalokati': 'jhalakathi',
    'netrakona': 'netrokona',
    'brahmanbaria': 'brahmanbaria',
    'bbaria': 'brahmanbaria',
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
    final districtIds = getDistrictsByDivision(
      divisionId,
    ).map((district) => district.id).toSet();
    return kUpazilas
        .where((upazila) => districtIds.contains(upazila.districtId))
        .toList(growable: false);
  }

  /// Searches [Division]s by Bengali or English name (supports legacy spellings
  /// like 'Chittagong' or 'Barisal').
  static List<Division> searchDivisions(String query) {
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return kDivisions;

    return kDivisions
        .where((division) {
          return _matches(
            query: normalized,
            nameEn: division.nameEn,
            nameBn: division.nameBn,
          );
        })
        .toList(growable: false);
  }

  /// Searches [District]s by Bengali or English name (supports legacy spellings
  /// like 'Jessore', 'Comilla', 'Bogra', 'Chittagong', etc.).
  ///
  /// Optionally filter by [divisionId].
  static List<District> searchDistricts(String query, {int? divisionId}) {
    final source = divisionId != null
        ? getDistrictsByDivision(divisionId)
        : kDistricts;
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return source;

    return source
        .where((district) {
          return _matches(
            query: normalized,
            nameEn: district.nameEn,
            nameBn: district.nameBn,
          );
        })
        .toList(growable: false);
  }

  /// Searches [Upazila]s by Bengali or English name.
  ///
  /// Optionally filter by [districtId].
  static List<Upazila> searchUpazilas(String query, {int? districtId}) {
    final source = districtId != null
        ? getUpazilasByDistrict(districtId)
        : kUpazilas;
    final normalized = _normalizeQuery(query);
    if (normalized.isEmpty) return source;

    return source
        .where((upazila) {
          return _matches(
            query: normalized,
            nameEn: upazila.nameEn,
            nameBn: upazila.nameBn,
          );
        })
        .toList(growable: false);
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

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
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
