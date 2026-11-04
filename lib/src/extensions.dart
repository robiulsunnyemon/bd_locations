import 'bd_locations_base.dart';
import 'models/district.dart';
import 'models/division.dart';
import 'models/upazila.dart';

/// Convenience relational getters on [Division].
extension DivisionRelationExtension on Division {
  /// Returns all [District]s under this division.
  List<District> get districts => BdLocations.getDistrictsByDivision(id);

  /// Returns all [Upazila]s under this division.
  List<Upazila> get upazilas => BdLocations.getUpazilasByDivision(id);
}

/// Convenience relational getters on [District].
extension DistrictRelationExtension on District {
  /// Returns the parent [Division] of this district.
  Division get division => BdLocations.getDivisionById(divisionId)!;

  /// Returns all [Upazila]s under this district.
  List<Upazila> get upazilas => BdLocations.getUpazilasByDistrict(id);
}

/// Convenience relational getters on [Upazila].
extension UpazilaRelationExtension on Upazila {
  /// Returns the parent [District] of this upazila.
  District get district => BdLocations.getDistrictById(districtId)!;

  /// Returns the parent [Division] of this upazila.
  Division get division => district.division;
}
