import 'package:bd_locations/bd_locations.dart';

void main() {
  // 1. Get counts of all administrative units
  print('Total Divisions: ${BdLocations.divisions.length}');
  print('Total Districts: ${BdLocations.districts.length}');
  print('Total Upazilas:  ${BdLocations.upazilas.length}\n');

  // 2. Relational navigation using extensions
  final dhakaDivision = BdLocations.getDivisionById(6)!;
  print(
    'Districts in ${dhakaDivision.nameBn} (${dhakaDivision.nameEn}): '
    '${dhakaDivision.districts.length}',
  );

  final sylhetDistrict = BdLocations.searchDistricts('Sylhet').first;
  print(
    'Upazilas in ${sylhetDistrict.nameBn}: '
    '${sylhetDistrict.upazilas.map((u) => u.nameBn).join(', ')}\n',
  );

  // 3. Bilingual & legacy-spelling search
  final searchResult = BdLocations.searchDistricts('Jessore').first;
  print(
    'Legacy Search "Jessore" -> ${searchResult.nameEn} (${searchResult.nameBn})',
  );

  // 4. Find nearest district from GPS coordinates
  final nearest = BdLocations.findNearestDistrict(21.4272, 92.0058);
  print('Nearest district to (21.4272, 92.0058): ${nearest.nameEn}');
}
