## 0.2.0

- **Added 4,540 Unions (`Union` model):**
  - Complete offline Union Parishad dataset of Bangladesh with Bengali & English names and official portal URLs.
  - Added `BdLocations.unions`, `BdLocations.getUnionById()`, `BdLocations.getUnionsByUpazila()`, `BdLocations.getUnionsByDistrict()`, and `BdLocations.searchUnions()`.
  - Added relational extensions: `upazila.unions`, `district.unions`, `union.upazila`, `union.district`, and `union.division`.
- **Added 1,349 Post Offices & Postcodes (`PostOffice` model):**
  - Complete 4-digit postal code dataset in both English (`'1207'`) and Bengali (`'১২০৭'`) digits.
  - Added `BdLocations.postOffices`, `BdLocations.findByPostcode()`, `BdLocations.isValidPostcode()`, `BdLocations.searchPostOffices()`, `BdLocations.getPostOfficesByDistrict()`, and `BdLocations.getPostOfficesByDivision()`.
  - Added relational extensions: `district.postOffices`, `division.postOffices`, `postOffice.district`, and `postOffice.division`.
- **Added Bilingual Address Formatter:**
  - Added `.formatAddress(inBangla: true/false)` extension on `District`, `Upazila`, `Union`, and `PostOffice`.

## 0.1.0

- Initial release of `bd_locations`.
- Added complete offline dataset for Bangladesh:
  - **8 Divisions** (`Division` model with Bengali & English names, coordinates, and portal URLs).
  - **64 Districts** (`District` model with Bengali & English names, coordinates, and portal URLs).
  - **495 Upazilas** (`Upazila` model with Bengali & English names and portal URLs, including newly formed Eidgaon, Madhyanagar, Dasar, and Shaistaganj).
- Added relational extensions (`division.districts`, `district.upazilas`, `upazila.district`, `upazila.division`).
- Added bilingual & legacy-spelling-aware search (`searchDivisions`, `searchDistricts`, `searchUpazilas`).
- Added Haversine geolocation helpers (`findNearestDistrict`, `findNearestDivision`, `distanceInKm`).
