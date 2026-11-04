# bd_locations 🇧🇩

[![pub package](https://img.shields.io/pub/v/bd_locations.svg)](https://pub.dev/packages/bd_locations)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](https://opensource.org/licenses/MIT)
[![Dart 3](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev)

A fast, zero-dependency, 100% offline geographic dataset of **Bangladesh** (**8 Divisions**, **64 Districts**, and **495 Upazilas**) in both **Bengali (বাংলা)** and **English**, complete with relational extensions, legacy-spelling-aware search, and GPS nearest-location helpers.

---

## ✨ Features

- 🚀 **Zero Async Overhead:** All data is compiled as `const` Dart objects—no JSON asset loading or `async/await` required.
- 🌐 **Bilingual Dataset:** Every Division, District, and Upazila includes both English (`nameEn`) and Bengali (`nameBn`) names plus official portal URLs.
- 🔗 **Relational Extensions:** Navigate effortlessly with `division.districts`, `district.upazilas`, `upazila.district`, and `upazila.division`.
- 🔍 **Smart Bilingual & Legacy Search:** Search in Bengali (`চট্টগ্রাম`, `যশোর`) or English—including legacy spellings (`Chittagong` ➔ `Chattogram`, `Jessore` ➔ `Jashore`, `Comilla` ➔ `Cumilla`, `Bogra` ➔ `Bogura`, `Barisal` ➔ `Barishal`).
- 📍 **Geolocation Helpers:** Find the nearest District or Division from any `(latitude, longitude)` using the Haversine formula.

---

## 📦 Installation

Add `bd_locations` to your `pubspec.yaml`:

```bash
# For Flutter projects
flutter pub add bd_locations

# For Pure Dart projects
dart pub add bd_locations
```

---

## 🚀 Quick Start

```dart
import 'package:bd_locations/bd_locations.dart';

void main() {
  // 1. Access complete datasets
  final divisions = BdLocations.divisions; // 8 Divisions
  final districts = BdLocations.districts; // 64 Districts
  final upazilas = BdLocations.upazilas;   // 495 Upazilas

  // 2. Navigate hierarchy using relational extensions
  final dhakaDiv = BdLocations.getDivisionById(6)!;
  print(dhakaDiv.nameBn); // ঢাকা
  print(dhakaDiv.districts.length); // 13

  final sylhetDistrict = BdLocations.searchDistricts('Sylhet').first;
  for (final upazila in sylhetDistrict.upazilas) {
    print('${upazila.nameBn} (${upazila.nameEn})');
  }

  // 3. Search in Bengali, English, or legacy spellings
  final jashore = BdLocations.searchDistricts('Jessore').first;
  print('${jashore.nameEn} - ${jashore.nameBn}'); // Jashore - যশোর

  final savar = BdLocations.searchUpazilas('সাভার').first;
  print('${savar.nameEn}, ${savar.district.nameEn}'); // Savar, Dhaka

  // 4. Find nearest district from GPS coordinates
  final nearest = BdLocations.findNearestDistrict(21.4272, 92.0058);
  print(nearest.nameEn); // Cox's Bazar
}
```

---

## 📱 Flutter Cascading Dropdown Example (Division ➔ District ➔ Upazila)

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

  @override
  Widget build(BuildContext context) {
    final districts = selectedDivision?.districts ?? [];
    final upazilas = selectedDistrict?.upazilas ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Division>(
          value: selectedDivision,
          hint: const Text('বিভাগ নির্বাচন করুন (Select Division)'),
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
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<District>(
          value: selectedDistrict,
          hint: const Text('জেলা নির্বাচন করুন (Select District)'),
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
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Upazila>(
          value: selectedUpazila,
          hint: const Text('উপজেলা নির্বাচন করুন (Select Upazila)'),
          items: upazilas.map((upa) {
            return DropdownMenuItem(
              value: upa,
              child: Text('${upa.nameBn} (${upa.nameEn})'),
            );
          }).toList(),
          onChanged: (upazila) {
            setState(() => selectedUpazila = upazila);
          },
        ),
      ],
    );
  }
}
```

---

## 📚 API Overview

| Method / Property | Return Type | Description |
| :--- | :--- | :--- |
| `BdLocations.divisions` | `List<Division>` | All 8 divisions of Bangladesh |
| `BdLocations.districts` | `List<District>` | All 64 districts of Bangladesh |
| `BdLocations.upazilas` | `List<Upazila>` | All 495 upazilas of Bangladesh |
| `BdLocations.getDivisionById(id)` | `Division?` | Lookup division by ID (`1..8`) |
| `BdLocations.getDistrictById(id)` | `District?` | Lookup district by ID (`1..64`) |
| `BdLocations.getUpazilaById(id)` | `Upazila?` | Lookup upazila by ID (`1..495`) |
| `BdLocations.getDistrictsByDivision(id)` | `List<District>` | All districts in a division |
| `BdLocations.getUpazilasByDistrict(id)` | `List<Upazila>` | All upazilas in a district |
| `BdLocations.searchDivisions(query)` | `List<Division>` | Search divisions in Bangla/English |
| `BdLocations.searchDistricts(query)` | `List<District>` | Search districts (supports legacy names) |
| `BdLocations.searchUpazilas(query)` | `List<Upazila>` | Search upazilas in Bangla/English |
| `BdLocations.findNearestDistrict(lat, lng)`| `District` | Nearest district by GPS coordinates |
| `BdLocations.findNearestDivision(lat, lng)`| `Division` | Nearest division by GPS coordinates |

---

## 📄 License

This package is licensed under the [MIT License](LICENSE).
