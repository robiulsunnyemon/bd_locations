## 0.1.0

- Initial release of `bd_locations`.
- Added complete offline dataset for Bangladesh:
  - **8 Divisions** (`Division` model with Bengali & English names, coordinates, and portal URLs).
  - **64 Districts** (`District` model with Bengali & English names, coordinates, and portal URLs).
  - **495 Upazilas** (`Upazila` model with Bengali & English names and portal URLs, including newly formed Eidgaon, Madhyanagar, Dasar, and Shaistaganj).
- Added relational extensions (`division.districts`, `district.upazilas`, `upazila.district`, `upazila.division`).
- Added bilingual & legacy-spelling-aware search (`searchDivisions`, `searchDistricts`, `searchUpazilas`).
- Added Haversine geolocation helpers (`findNearestDistrict`, `findNearestDivision`, `distanceInKm`).
