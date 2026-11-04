import 'package:bd_locations/bd_locations.dart';
import 'package:test/test.dart';

void main() {
  group('Dataset Integrity Tests', () {
    test('contains exactly 8 divisions, 64 districts, and 495 upazilas', () {
      expect(BdLocations.divisions.length, equals(8));
      expect(BdLocations.districts.length, equals(64));
      expect(BdLocations.upazilas.length, equals(495));
    });

    test('every district belongs to a valid division', () {
      for (final district in BdLocations.districts) {
        final division = BdLocations.getDivisionById(district.divisionId);
        expect(
          division,
          isNotNull,
          reason: 'District ${district.nameEn} has invalid divisionId',
        );
      }
    });

    test('every upazila belongs to a valid district', () {
      for (final upazila in BdLocations.upazilas) {
        final district = BdLocations.getDistrictById(upazila.districtId);
        expect(
          district,
          isNotNull,
          reason: 'Upazila ${upazila.nameEn} has invalid districtId',
        );
      }
    });
  });

  group('Lookup & Relational Queries', () {
    test(
      'getDivisionById, getDistrictById, and getUpazilaById work properly',
      () {
        final dhakaDiv = BdLocations.getDivisionById(6);
        expect(dhakaDiv, isNotNull);
        expect(dhakaDiv!.nameEn, equals('Dhaka'));
        expect(dhakaDiv.nameBn, equals('ঢাকা'));

        final dhakaDist = BdLocations.getDistrictById(47);
        expect(dhakaDist, isNotNull);
        expect(dhakaDist!.nameEn, equals('Dhaka'));

        expect(BdLocations.getDivisionById(999), isNull);
        expect(BdLocations.getDistrictById(999), isNull);
        expect(BdLocations.getUpazilaById(9999), isNull);
      },
    );

    test('relational extensions resolve parent and children accurately', () {
      final sylhetDiv = BdLocations.getDivisionById(5)!;
      expect(sylhetDiv.districts.length, equals(4));
      expect(sylhetDiv.upazilas.length, greaterThan(35));

      final sylhetDist = BdLocations.getDistrictById(36)!;
      expect(sylhetDist.division, equals(sylhetDiv));
      expect(sylhetDist.upazilas, isNotEmpty);

      final firstUpazila = sylhetDist.upazilas.first;
      expect(firstUpazila.district, equals(sylhetDist));
      expect(firstUpazila.division, equals(sylhetDiv));
    });
  });

  group('Bilingual & Legacy Spelling Search', () {
    test('searches divisions in English, Bengali, and legacy spellings', () {
      expect(BdLocations.searchDivisions('ঢাকা').first.nameEn, equals('Dhaka'));
      expect(
        BdLocations.searchDivisions('Chittagong').first.nameBn,
        equals('চট্টগ্রাম'),
      );
      expect(
        BdLocations.searchDivisions('Barisal').first.nameEn,
        equals('Barishal'),
      );
    });

    test('searches districts in Bengali, English, and legacy spellings', () {
      expect(
        BdLocations.searchDistricts('যশোর').first.nameEn,
        equals('Jashore'),
      );
      expect(
        BdLocations.searchDistricts('Jessore').first.nameEn,
        equals('Jashore'),
      );
      expect(
        BdLocations.searchDistricts('Comilla').first.nameEn,
        equals('Cumilla'),
      );
      expect(
        BdLocations.searchDistricts('Bogra').first.nameEn,
        equals('Bogura'),
      );
    });

    test('searches upazilas in Bengali and English', () {
      final savarBn = BdLocations.searchUpazilas('সাভার');
      expect(savarBn, isNotEmpty);
      expect(savarBn.first.nameEn, equals('Savar'));

      final eidgaon = BdLocations.searchUpazilas('Eidgaon');
      expect(eidgaon, isNotEmpty);
      expect(eidgaon.first.nameBn, equals('ঈদগাঁও'));
    });
  });

  group('Geolocation & Distance Utilities', () {
    test(
      'findNearestDistrict and findNearestDivision return Dhaka for Dhaka coordinates',
      () {
        final nearestDistrict = BdLocations.findNearestDistrict(
          23.8103,
          90.4125,
        );
        expect(nearestDistrict.nameEn, equals('Dhaka'));

        final nearestDivision = BdLocations.findNearestDivision(
          23.8103,
          90.4125,
        );
        expect(nearestDivision.nameEn, equals('Dhaka'));
      },
    );

    test(
      'distanceInKm calculates reasonable distance between Dhaka and Chattogram',
      () {
        final distance = BdLocations.distanceInKm(
          23.8103,
          90.4125,
          22.3569,
          91.7832,
        );
        expect(distance, inInclusiveRange(200.0, 230.0));
      },
    );
  });

  group('JSON Serialization', () {
    test(
      'Division, District, and Upazila serialize and deserialize accurately',
      () {
        final div = BdLocations.divisions.first;
        expect(Division.fromJson(div.toJson()), equals(div));

        final dist = BdLocations.districts.first;
        expect(District.fromJson(dist.toJson()), equals(dist));

        final upa = BdLocations.upazilas.first;
        expect(Upazila.fromJson(upa.toJson()), equals(upa));
      },
    );
  });
}
