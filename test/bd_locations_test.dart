import 'package:bd_locations/bd_locations.dart';
import 'package:test/test.dart';

void main() {
  group('Dataset Integrity Tests', () {
    test(
        'contains 8 divisions, 64 districts, 495 upazilas, 4540 unions, and 1349 post offices',
        () {
      expect(BdLocations.divisions.length, equals(8));
      expect(BdLocations.districts.length, equals(64));
      expect(BdLocations.upazilas.length, equals(495));
      expect(BdLocations.unions.length, equals(4540));
      expect(BdLocations.postOffices.length, equals(1349));
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

    test('every union belongs to a valid upazila', () {
      for (final union in BdLocations.unions) {
        final upazila = BdLocations.getUpazilaById(union.upazilaId);
        expect(
          upazila,
          isNotNull,
          reason: 'Union ${union.nameEn} has invalid upazilaId',
        );
      }
    });

    test('every post office belongs to a valid district and division', () {
      for (final po in BdLocations.postOffices) {
        expect(BdLocations.getDistrictById(po.districtId), isNotNull);
        expect(BdLocations.getDivisionById(po.divisionId), isNotNull);
      }
    });
  });

  group('Lookup & Relational Queries', () {
    test(
        'getDivisionById, getDistrictById, getUpazilaById, and getUnionById work properly',
        () {
      final dhakaDiv = BdLocations.getDivisionById(6);
      expect(dhakaDiv, isNotNull);
      expect(dhakaDiv!.nameEn, equals('Dhaka'));
      expect(dhakaDiv.nameBn, equals('ঢাকা'));

      final dhakaDist = BdLocations.getDistrictById(47);
      expect(dhakaDist, isNotNull);
      expect(dhakaDist!.nameEn, equals('Dhaka'));

      final firstUnion = BdLocations.getUnionById(1);
      expect(firstUnion, isNotNull);

      expect(BdLocations.getDivisionById(999), isNull);
      expect(BdLocations.getDistrictById(999), isNull);
      expect(BdLocations.getUpazilaById(9999), isNull);
      expect(BdLocations.getUnionById(99999), isNull);
    });

    test(
        'relational extensions resolve parent and children accurately across all 4 tiers',
        () {
      final sylhetDiv = BdLocations.getDivisionById(5)!;
      expect(sylhetDiv.districts.length, equals(4));
      expect(sylhetDiv.upazilas.length, greaterThan(35));
      expect(sylhetDiv.postOffices, isNotEmpty);

      final sylhetDist = BdLocations.getDistrictById(36)!;
      expect(sylhetDist.division, equals(sylhetDiv));
      expect(sylhetDist.upazilas, isNotEmpty);
      expect(sylhetDist.unions, isNotEmpty);
      expect(sylhetDist.postOffices, isNotEmpty);

      final firstUpazila = sylhetDist.upazilas.first;
      expect(firstUpazila.district, equals(sylhetDist));
      expect(firstUpazila.division, equals(sylhetDiv));
      expect(firstUpazila.unions, isNotEmpty);

      final firstUnion = firstUpazila.unions.first;
      expect(firstUnion.upazila, equals(firstUpazila));
      expect(firstUnion.district, equals(sylhetDist));
      expect(firstUnion.division, equals(sylhetDiv));
    });
  });

  group('Unions & Postcode Lookups (v0.2.0)', () {
    test(
        'findByPostcode and isValidPostcode support both English and Bengali digits',
        () {
      expect(BdLocations.isValidPostcode('1207'), isTrue);
      expect(BdLocations.isValidPostcode('১২০৭'), isTrue);
      expect(BdLocations.isValidPostcode('9999'), isFalse);

      final mohammadpurEn = BdLocations.findByPostcode('1207');
      final mohammadpurBn = BdLocations.findByPostcode('১২০৭');
      expect(mohammadpurEn, isNotEmpty);
      expect(mohammadpurEn, equals(mohammadpurBn));
      expect(mohammadpurEn.first.district.nameEn, equals('Dhaka'));
    });

    test('searchUnions and searchPostOffices return matching records', () {
      final unions = BdLocations.searchUnions('তেঁতুলঝোড়া');
      expect(unions, isNotEmpty);

      final postOffices = BdLocations.searchPostOffices('Banani');
      expect(postOffices, isNotEmpty);
      expect(postOffices.first.postcode, equals('1213'));
    });

    test('formatAddress formats bilingual addresses cleanly', () {
      final savar = BdLocations.searchUpazilas('Savar').first;
      expect(
        savar.formatAddress(inBangla: false),
        equals('Savar, Dhaka, Dhaka Division'),
      );
      expect(
        savar.formatAddress(inBangla: true),
        equals('সাভার, ঢাকা, ঢাকা বিভাগ'),
      );
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
      final nearestDistrict = BdLocations.findNearestDistrict(23.8103, 90.4125);
      expect(nearestDistrict.nameEn, equals('Dhaka'));

      final nearestDivision = BdLocations.findNearestDivision(23.8103, 90.4125);
      expect(nearestDivision.nameEn, equals('Dhaka'));
    });

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
    });
  });

  group('JSON Serialization', () {
    test(
        'Division, District, Upazila, Union, and PostOffice serialize and deserialize accurately',
        () {
      final div = BdLocations.divisions.first;
      expect(Division.fromJson(div.toJson()), equals(div));

      final dist = BdLocations.districts.first;
      expect(District.fromJson(dist.toJson()), equals(dist));

      final upa = BdLocations.upazilas.first;
      expect(Upazila.fromJson(upa.toJson()), equals(upa));

      final uni = BdLocations.unions.first;
      expect(Union.fromJson(uni.toJson()), equals(uni));

      final po = BdLocations.postOffices.first;
      expect(PostOffice.fromJson(po.toJson()), equals(po));
    });
  });
}
