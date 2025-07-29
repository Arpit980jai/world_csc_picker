import 'package:flutter/material.dart';
import 'package:world_csc_picker/country_state_city_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = CountryStateCityData();
  await data.load();
  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  final CountryStateCityData data;
  const MyApp({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('World_CSC_Picker Example')),
        body: Center(
          child: CountryStateCityPicker(
            data: data,
            onSelection: (country, state, city) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chose ${city.name}, $state in $country'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
