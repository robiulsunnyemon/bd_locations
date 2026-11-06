import 'package:bd_locations/bd_locations.dart';

void main() {
  // 1. Get counts of all administrative units
  print('Total Divisions:    ${BdLocations.divisions.length}');
  print('Total Districts:    ${BdLocations.districts.length}');
  print('Total Upazilas:     ${BdLocations.upazilas.length}');
  print('Total Unions:       ${BdLocations.unions.length}');
  print('Total Post Offices: ${BdLocations.postOffices.length}\n');

  // 2. 4-Tier Relational Navigation (Division -> District -> Upazila -> Union)
  final savar = BdLocations.searchUpazilas('সাভার').first;
  print('Upazila Full Address (BN): ${savar.formatAddress(inBangla: true)}');
  print('Unions in ${savar.nameBn} (${savar.unions.length}): '
      '${savar.unions.take(5).map((u) => u.nameBn).join(', ')}...\n');

  // 3. Postcode Lookup & Validation (English & Bangla digits)
  final postOffices = BdLocations.findByPostcode('১২০৭');
  for (final po in postOffices) {
    print('Postcode ১২০৭ -> ${po.formatAddress()}');
  }

  // 4. Legacy-spelling search & GPS Nearest District
  final searchResult = BdLocations.searchDistricts('Jessore').first;
  print(
    '\nLegacy Search "Jessore" -> ${searchResult.nameEn} (${searchResult.nameBn})',
  );

  final nearest = BdLocations.findNearestDistrict(21.4272, 92.0058);
  print('Nearest district to (21.4272, 92.0058): ${nearest.nameEn}');
}
