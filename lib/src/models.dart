import 'dart:convert';
import 'package:flutter/services.dart';

class City {
  final String name;
  final double lat;
  final double lng;
  final int population;

  City({
    required this.name,
    required this.lat,
    required this.lng,
    required this.population,
  });

  factory City.fromJson(Map<String, dynamic> j) => City(
    name: j['city'] as String,
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
    // If population is null, default to 0
    population: j['population'] != null
        ? (j['population'] as num).toInt()
        : 0,
  );
}

class CountryStateCityData {
  late final Map<String, Map<String, List<City>>> _data;

  Future<void> load() async {
    // 1️⃣ Load JSON
    final jsonStr = await rootBundle.loadString('assets/worldcities.json');
    // 2️⃣ Decode top-level map: country -> (state -> [ cityJson... ])
    final decoded = json.decode(jsonStr) as Map<String, dynamic>;

    _data = decoded.map((country, states) {
      final stateMap = (states as Map<String, dynamic>).map<String, List<City>>(
            (state, citiesList) {
          final cityJsonList = (citiesList as List<dynamic>)
              .cast<Map<String, dynamic>>();
          final cityObjs = cityJsonList.map(City.fromJson).toList();
          return MapEntry(state, cityObjs);
        },
      );
      return MapEntry(country, stateMap);
    });
  }

  List<String> get countries => _data.keys.toList();

  List<String> statesOf(String country) =>
      _data[country]?.keys.toList() ?? <String>[];

  List<City> citiesOf(String country, String state) =>
      _data[country]?[state] ?? <City>[];
}
