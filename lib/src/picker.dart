import 'package:flutter/material.dart';
import 'models.dart';

typedef OnSelection = void Function(
    String country,
    String state,
    City city,
    );

class CountryStateCityPicker extends StatefulWidget {
  final CountryStateCityData data;
  final OnSelection onSelection;

  const CountryStateCityPicker({
    Key? key,
    required this.data,
    required this.onSelection,
  }) : super(key: key);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<CountryStateCityPicker> {
  String? _country;
  String? _state;
  City? _city;

  @override
  Widget build(BuildContext context) {
    final countries = widget.data.countries;
    final states = _country != null
        ? widget.data.statesOf(_country!)
        : <String>[];
    final cities = (_country != null && _state != null)
        ? widget.data.citiesOf(_country!, _state!)
        : <City>[];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Country selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select country'),
                  value: _country,
                  menuMaxHeight: 200,
                  items: countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (c) {
                    if (c == null) return;
                    setState(() {
                      _country = c;
                      _state = null;
                      _city = null;
                    });
                  },
                ),
              ),
            ),
          ),

          // State selector
          if (states.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'State / Province',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Select state'),
                    value: _state,
                    menuMaxHeight: 200,
                    items: states
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (s) {
                      if (s == null) return;
                      setState(() {
                        _state = s;
                        _city = null;
                      });
                    },
                  ),
                ),
              ),
            ),

          // City selector
          if (cities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<City>(
                    isExpanded: true,
                    hint: const Text('Select city'),
                    value: _city,
                    menuMaxHeight: 200,
                    items: cities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (c) {
                      if (c == null) return;
                      setState(() => _city = c);
                      widget.onSelection(_country!, _state!, c);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
