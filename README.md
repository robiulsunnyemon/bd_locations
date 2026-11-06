# bd_locations

[![pub package](https://img.shields.io/pub/v/bd_locations.svg)](https://pub.dev/packages/bd_locations)
[![pub points](https://img.shields.io/pub/points/bd_locations)](https://pub.dev/packages/bd_locations/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](https://opensource.org/licenses/MIT)
[![Dart 3](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev)

A fast, zero-dependency, 100% offline geographic dataset of **Bangladesh** in both **Bengali** and **English**. Built for Flutter and Dart applications requiring administrative hierarchy navigation, bilingual search, postal code validation, address formatting, and coordinate-based location lookup.

---

## Dataset Summary

| Administrative Unit | Count | Model Class | Bilingual Names | Coordinates | Parent Reference |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Divisions** | 8 | `Division` | English & Bengali | Latitude & Longitude | — |
| **Districts** | 64 | `District` | English & Bengali | Latitude & Longitude | `divisionId` |
| **Upazilas / Thanas** | 495 | `Upazila` | English & Bengali | — | `districtId` |
| **Unions** | 4,540 | `Union` | English & Bengali | — | `upazilaId` |
| **Post Offices / Postcodes** | 1,349 | `PostOffice` | English & Bengali digits | — | `districtId`, `divisionId` |

---

## Key Features

- **Zero Async Overhead:** All records are compiled as `const` Dart objects. No asset bundling, file I/O, or `Future`/`async` initialization is required.
- **Zero External Dependencies:** Pure Dart implementation compatible with Android, iOS, Web, macOS, Windows, Linux, and Dart server/CLI environments.
- **4-Tier Relational Hierarchy:** Traverse seamlessly between Divisions, Districts, Upazilas, Unions, and Post Offices using intuitive extension getters.
- **Bilingual & Legacy-Spelling Search:** Query locations in Bengali (`ঢাকা`, `চট্টগ্রাম`, `সাভার`) or English—including automatic normalization for common legacy spellings (`Chittagong` -> `Chattogram`, `Jessore` -> `Jashore`, `Comilla` -> `Cumilla`, `Bogra` -> `Bogura`, `Barisal` -> `Barishal`).
- **Postal Code Lookup & Validation:** Search and validate 4-digit Bangladesh postal codes in both English (`1207`) and Bengali (`১২০৭`) digits.
- **Bilingual Address Formatter:** Generate formatted address strings in either Bengali or English with a single method call.
- **Geolocation Utilities:** Compute great-circle distances and identify the nearest District or Division from any `(latitude, longitude)` pair using the Haversine formula.

---

## Installation

Run the following command in your project terminal:

```bash
# For Flutter projects
flutter pub add bd_locations

# For Pure Dart projects
dart pub add bd_locations
```

Or add `bd_locations` manually to your `pubspec.yaml`:

```yaml
dependencies:
  bd_locations: ^0.2.0
```

Then import the package:

```dart
import 'package:bd_locations/bd_locations.dart';
```

---

## Usage Guide

### 1. Accessing Complete Datasets and Lookup by ID

All datasets are available synchronously as immutable lists:

```dart
final divisions = BdLocations.divisions;     // 8 Divisions
final districts = BdLocations.districts;     // 64 Districts
final upazilas = BdLocations.upazilas;       // 495 Upazilas
final unions = BdLocations.unions;           // 4,540 Unions
final postOffices = BdLocations.postOffices; // 1,349 Post Offices

// Direct lookup by ID
final dhakaDivision = BdLocations.getDivisionById(6);
final dhakaDistrict = BdLocations.getDistrictById(47);
final savarUpazila = BdLocations.getUpazilaById(365);
final firstUnion = BdLocations.getUnionById(1);
```

### 2. Relational Navigation (Top-Down and Bottom-Up)

Use built-in relational extensions to navigate down or up the administrative hierarchy without manual filtering:

```dart
// Top-down navigation: Division -> Districts -> Upazilas -> Unions
final sylhetDivision = BdLocations.getDivisionById(5)!;
final sylhetDistricts = sylhetDivision.districts;       // 4 Districts
final sylhetUpazilas = sylhetDivision.upazilas;         // All Upazilas in Sylhet Division
final sylhetPostOffices = sylhetDivision.postOffices;   // All Post Offices in Sylhet Division

final sylhetSadar = sylhetDistricts.first.upazilas.first;
final unionsInUpazila = sylhetSadar.unions;             // All Unions in this Upazila

// Bottom-up navigation: Union -> Upazila -> District -> Division
final union = unionsInUpazila.first;
print(union.nameEn);            // Union name
print(union.upazila.nameEn);    // Parent Upazila name
print(union.district.nameEn);   // Parent District name
print(union.division.nameEn);   // Parent Division name
```

### 3. Bilingual and Legacy-Spelling Search

Search across any administrative level using Bengali text, official English names, or legacy English spellings:

```dart
// Search by legacy English spelling
final jashore = BdLocations.searchDistricts('Jessore').first;
print('${jashore.nameEn} (${jashore.nameBn})'); // Jashore (যশোর)

final cumilla = BdLocations.searchDistricts('Comilla').first;
print('${cumilla.nameEn} (${cumilla.nameBn})'); // Cumilla (কুমিল্লা)

// Search in Bengali
final savar = BdLocations.searchUpazilas('সাভার').first;
print('${savar.nameEn} - ${savar.district.nameEn}'); // Savar - Dhaka

// Scoped search (e.g., search Upazilas within a specific District)
final dhakaUpazilas = BdLocations.searchUpazilas('Dhamrai', districtId: 47);

// Search Unions
final unions = BdLocations.searchUnions('তেঁতুলঝোড়া');
```

#### Supported Legacy Spelling Aliases

| Legacy / Alternative Query | Resolved Official Name |
| :--- | :--- |
| `Chittagong`, `Chattagram` | `Chattogram` |
| `Comilla` | `Cumilla` |
| `Bogra` | `Bogura` |
| `Jessore` | `Jashore` |
| `Barisal` | `Barishal` |
| `Coxs Bazar`, `Coxsbazar` | `Cox's Bazar` |
| `Chapai Nawabganj`, `Nawabganj` | `Chapainawabganj` |
| `Jhalokati`, `Jhalokathi` | `Jhalakathi` |
| `Netrakona` | `Netrokona` |
| `Khagrachari` | `Khagrachhari` |
| `Laxmipur`, `Laksmipur` | `Lakshmipur` |
| `Maulvibazar` | `Moulvibazar` |
| `Bbaria` | `Brahmanbaria` |

### 4. Postal Code Lookup, Search, and Form Validation

Look up or validate 4-digit postal codes using either English (`1207`) or Bengali (`১২০৭`) numerals:

```dart
// Validate postal codes in forms
print(BdLocations.isValidPostcode('1207')); // true
print(BdLocations.isValidPostcode('১২০৭')); // true
print(BdLocations.isValidPostcode('9999')); // false

// Find post offices by postal code
final offices = BdLocations.findByPostcode('১২০৭');
for (final po in offices) {
  print('${po.subOfficeEn} (${po.postcode}) - ${po.district.nameEn}');
  // Mohammadpur Housing (1207) - Dhaka
}

// Search post offices by sub-office name, thana, or code
final bananiOffices = BdLocations.searchPostOffices('Banani');
print(bananiOffices.first.postcode);   // 1213
print(bananiOffices.first.postcodeBn); // ১২১৩
```

### 5. Bilingual Address Formatting

Generate human-readable addresses from `District`, `Upazila`, `Union`, or `PostOffice` instances:

```dart
final savar = BdLocations.searchUpazilas('Savar').first;
print(savar.formatAddress(inBangla: false));
// Output: Savar, Dhaka, Dhaka Division

print(savar.formatAddress(inBangla: true));
// Output: সাভার, ঢাকা, ঢাকা বিভাগ

final union = savar.unions.first;
print(union.formatAddress(inBangla: true));
// Output: সাভার, সাভার, ঢাকা

final postOffice = BdLocations.findByPostcode('1207').first;
print(postOffice.formatAddress(inBangla: false));
// Output: Mohammadpur Housing (1207), Mohammadpur, Dhaka
```

### 6. Geolocation and Distance Calculation

Find the closest District or Division to a user's GPS coordinates or calculate the distance in kilometers between two coordinates:

```dart
// Find nearest District and Division
final nearestDistrict = BdLocations.findNearestDistrict(21.4272, 92.0058);
print(nearestDistrict.nameEn); // Cox's Bazar

final nearestDivision = BdLocations.findNearestDivision(24.8949, 91.8687);
print(nearestDivision.nameEn); // Sylhet

// Calculate distance between Dhaka and Chattogram in kilometers
final distanceKm = BdLocations.distanceInKm(
  23.8103, 90.4125, // Dhaka
  22.3569, 91.7832, // Chattogram
);
print('${distanceKm.toStringAsFixed(1)} km'); // ~214.2 km
```

### 7. JSON Serialization

Every model (`Division`, `District`, `Upazila`, `Union`, and `PostOffice`) supports `toJson()` and `fromJson()` for local storage or API payloads:

```dart
final district = BdLocations.getDistrictById(47)!;
final Map<String, dynamic> jsonMap = district.toJson();
final District restored = District.fromJson(jsonMap);
```

---

## Flutter 4-Level Cascading Dropdown Example

Below is a complete Flutter widget demonstrating a cascading **Division -> District -> Upazila -> Union** selector:

```dart
import 'package:bd_locations/bd_locations.dart';
import 'package:flutter/material.dart';

class BdAddressPicker extends StatefulWidget {
  const BdAddressPicker({super.key});

  @override
  State<BdAddressPicker> createState() => _BdAddressPickerState();
}

class _BdAddressPickerState extends State<BdAddressPicker> {
  Division? selectedDivision;
  District? selectedDistrict;
  Upazila? selectedUpazila;
  Union? selectedUnion;

  @override
  Widget build(BuildContext context) {
    final districts = selectedDivision?.districts ?? const [];
    final upazilas = selectedDistrict?.upazilas ?? const [];
    final unions = selectedUpazila?.unions ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Division>(
          value: selectedDivision,
          hint: const Text('Select Division (বিভাগ নির্বাচন করুন)'),
          items: BdLocations.divisions.map((div) {
            return DropdownMenuItem(
              value: div,
              child: Text('${div.nameBn} (${div.nameEn})'),
            );
          }).toList(),
          onChanged: (division) {
            setState(() {
              selectedDivision = division;
              selectedDistrict = null;
              selectedUpazila = null;
              selectedUnion = null;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<District>(
          value: selectedDistrict,
          hint: const Text('Select District (জেলা নির্বাচন করুন)'),
          items: districts.map((dist) {
            return DropdownMenuItem(
              value: dist,
              child: Text('${dist.nameBn} (${dist.nameEn})'),
            );
          }).toList(),
          onChanged: (district) {
            setState(() {
              selectedDistrict = district;
              selectedUpazila = null;
              selectedUnion = null;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Upazila>(
          value: selectedUpazila,
          hint: const Text('Select Upazila (উপজেলা নির্বাচন করুন)'),
          items: upazilas.map((upa) {
            return DropdownMenuItem(
              value: upa,
              child: Text('${upa.nameBn} (${upa.nameEn})'),
            );
          }).toList(),
          onChanged: (upazila) {
            setState(() {
              selectedUpazila = upazila;
              selectedUnion = null;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Union>(
          value: selectedUnion,
          hint: const Text('Select Union (ইউনিয়ন নির্বাচন করুন)'),
          items: unions.map((uni) {
            return DropdownMenuItem(
              value: uni,
              child: Text('${uni.nameBn} (${uni.nameEn})'),
            );
          }).toList(),
          onChanged: (union) {
            setState(() => selectedUnion = union);
          },
        ),
      ],
    );
  }
}
```

---

## API Reference

### `BdLocations` Static Methods and Getters

| Member | Return Type | Description |
| :--- | :--- | :--- |
| `BdLocations.divisions` | `List<Division>` | Returns all 8 divisions of Bangladesh. |
| `BdLocations.districts` | `List<District>` | Returns all 64 districts of Bangladesh. |
| `BdLocations.upazilas` | `List<Upazila>` | Returns all 495 upazilas of Bangladesh. |
| `BdLocations.unions` | `List<Union>` | Returns all 4,540 unions of Bangladesh. |
| `BdLocations.postOffices` | `List<PostOffice>` | Returns all 1,349 post offices and postcodes. |
| `BdLocations.getDivisionById(id)` | `Division?` | Finds a division by its ID (`1..8`). |
| `BdLocations.getDistrictById(id)` | `District?` | Finds a district by its ID (`1..64`). |
| `BdLocations.getUpazilaById(id)` | `Upazila?` | Finds an upazila by its ID (`1..495`). |
| `BdLocations.getUnionById(id)` | `Union?` | Finds a union by its ID. |
| `BdLocations.getDistrictsByDivision(divisionId)` | `List<District>` | Returns all districts in a division. |
| `BdLocations.getUpazilasByDistrict(districtId)` | `List<Upazila>` | Returns all upazilas in a district. |
| `BdLocations.getUpazilasByDivision(divisionId)` | `List<Upazila>` | Returns all upazilas in a division. |
| `BdLocations.getUnionsByUpazila(upazilaId)` | `List<Union>` | Returns all unions in an upazila. |
| `BdLocations.getUnionsByDistrict(districtId)` | `List<Union>` | Returns all unions in a district. |
| `BdLocations.getPostOfficesByDistrict(districtId)` | `List<PostOffice>` | Returns all post offices in a district. |
| `BdLocations.getPostOfficesByDivision(divisionId)` | `List<PostOffice>` | Returns all post offices in a division. |
| `BdLocations.findByPostcode(postcode)` | `List<PostOffice>` | Finds post offices by English or Bengali 4-digit code. |
| `BdLocations.isValidPostcode(postcode)` | `bool` | Checks if a 4-digit postcode exists in Bangladesh. |
| `BdLocations.searchDivisions(query)` | `List<Division>` | Searches divisions in Bengali or English. |
| `BdLocations.searchDistricts(query, {divisionId})` | `List<District>` | Searches districts in Bengali or English. |
| `BdLocations.searchUpazilas(query, {districtId})` | `List<Upazila>` | Searches upazilas in Bengali or English. |
| `BdLocations.searchUnions(query, {upazilaId})` | `List<Union>` | Searches unions in Bengali or English. |
| `BdLocations.searchPostOffices(query, {districtId})` | `List<PostOffice>` | Searches post offices by code, sub-office, or upazila. |
| `BdLocations.findNearestDistrict(lat, lng)` | `District` | Finds the nearest district to `(lat, lng)`. |
| `BdLocations.findNearestDivision(lat, lng)` | `Division` | Finds the nearest division to `(lat, lng)`. |
| `BdLocations.distanceInKm(lat1, lng1, lat2, lng2)` | `double` | Calculates Haversine distance in kilometers. |

---

## Contributing

Contributions, bug reports, and dataset improvements are welcome! Please open an issue or submit a pull request on the [GitHub Repository](https://github.com/robiulsunnyemon/bd_locations).

## License

This project is licensed under the [MIT License](LICENSE).
