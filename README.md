# bd_locations 🇧🇩

[![pub package](https://img.shields.io/pub/v/bd_locations.svg)](https://pub.dev/packages/bd_locations)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](https://opensource.org/licenses/MIT)
[![Dart 3](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev)

A fast, zero-dependency, 100% offline geographic dataset of **Bangladesh** (**8 Divisions**, **64 Districts**, **495 Upazilas**, **4,540 Unions**, and **1,349 Post Offices / Postcodes**) in both **Bengali (বাংলা)** and **English**, complete with relational extensions, legacy-spelling-aware search, address formatting, and GPS nearest-location helpers.

---

## ✨ Features

- 🚀 **Zero Async Overhead:** All data is compiled as `const` Dart objects—no JSON asset loading or `async/await` required.
- 🌐 **Complete 4-Tier Hierarchy + Postcodes:**
  - **8 Divisions** (`Division`)
  - **64 Districts** (`District`)
  - **495 Upazilas** (`Upazila`)
  - **4,540 Unions** (`Union`) *(New in v0.2.0!)*
  - **1,349 Post Offices & Postcodes** (`PostOffice`) in English (`1207`) & Bengali (`১২০৭`) digits *(New in v0.2.0!)*
- 🔗 **Relational Extensions:** Navigate effortlessly with `division.districts`, `district.upazilas`, `upazila.unions`, `union.upazila`, `district.postOffices`, etc.
- 🏷️ **Bilingual Address Formatter:** Format complete addresses in 1 line with `.formatAddress(inBangla: true)`.
- 🔍 **Smart Bilingual & Legacy Search:** Search in Bengali (`চট্টগ্রাম`, `যশোর`, `সাভার`) or English—including legacy spellings (`Chittagong` ➔ `Chattogram`, `Jessore` ➔ `Jashore`, `Comilla` ➔ `Cumilla`, `Bogra` ➔ `Bogura`, `Barisal` ➔ `Barishal`).
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
  // 1. Access complete offline datasets
  final divisions = BdLocations.divisions;     // 8 Divisions
  final districts = BdLocations.districts;     // 64 Districts
  final upazilas = BdLocations.upazilas;       // 495 Upazilas
  final unions = BdLocations.unions;           // 4,540 Unions
  final postOffices = BdLocations.postOffices; // 1,349 Post Offices

  // 2. Navigate 4-tier hierarchy using relational extensions
  final savar = BdLocations.searchUpazilas('সাভার').first;
  print(savar.formatAddress(inBangla: true)); // সাভার, ঢাকা, ঢাকা বিভাগ
  print(savar.unions.length); // 12 Unions under Savar

  // 3. Postcode Lookup & Validation (supports English & Bangla digits!)
  print(BdLocations.isValidPostcode('১২০৭')); // true
  final offices = BdLocations.findByPostcode('1207');
  print(offices.first.formatAddress());
  // Mohammadpur Housing (1207), Mohammadpur, Dhaka

  // 4. Search in Bengali, English, or legacy spellings
  final jashore = BdLocations.searchDistricts('Jessore').first;
  print('${jashore.nameEn} - ${jashore.nameBn}'); // Jashore - যশোর

  // 5. Find nearest district from GPS coordinates
  final nearest = BdLocations.findNearestDistrict(21.4272, 92.0058);
  print(nearest.nameEn); // Cox's Bazar
}
```

---

## 📱 Flutter 4-Level Cascading Dropdown Example (Division ➔ District ➔ Upazila ➔ Union)

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
    final districts = selectedDivision?.districts ?? [];
    final upazilas = selectedDistrict?.upazilas ?? [];
    final unions = selectedUpazila?.unions ?? [];

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
              selectedUnion = null;
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
              selectedUnion = null;
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
            setState(() {
              selectedUpazila = upazila;
              selectedUnion = null;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Union>(
          value: selectedUnion,
          hint: const Text('ইউনিয়ন নির্বাচন করুন (Select Union)'),
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

## 📚 API Overview

| Method / Property | Return Type | Description |
| :--- | :--- | :--- |
| `BdLocations.divisions` | `List<Division>` | All 8 divisions of Bangladesh |
| `BdLocations.districts` | `List<District>` | All 64 districts of Bangladesh |
| `BdLocations.upazilas` | `List<Upazila>` | All 495 upazilas of Bangladesh |
| `BdLocations.unions` | `List<Union>` | All 4,540 unions of Bangladesh |
| `BdLocations.postOffices` | `List<PostOffice>` | All 1,349 post offices & postcodes |
| `BdLocations.getUnionsByUpazila(id)` | `List<Union>` | All unions in an upazila |
| `BdLocations.findByPostcode(code)` | `List<PostOffice>` | Lookup post offices by English/Bangla code |
| `BdLocations.isValidPostcode(code)` | `bool` | Validate a 4-digit postcode |
| `BdLocations.searchDivisions(query)` | `List<Division>` | Search divisions in Bangla/English |
| `BdLocations.searchDistricts(query)` | `List<District>` | Search districts (supports legacy names) |
| `BdLocations.searchUpazilas(query)` | `List<Upazila>` | Search upazilas in Bangla/English |
| `BdLocations.searchUnions(query)` | `List<Union>` | Search unions in Bangla/English |
| `BdLocations.searchPostOffices(query)` | `List<PostOffice>` | Search post offices by code or name |
| `BdLocations.findNearestDistrict(lat, lng)`| `District` | Nearest district by GPS coordinates |

---

## 📄 License

This package is licensed under the [MIT License](LICENSE).
