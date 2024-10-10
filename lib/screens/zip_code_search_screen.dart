import 'package:flutter/material.dart';
import '../models/country.dart';
import '../widgets/dropdown_countries.dart';
import '../widgets/text_field_validated.dart';
import '../validators/validator_input_formater.dart';
import '../validators/regex_validator.dart';
import '../services/zippopotam_service.dart';
import '../widgets/show_zippopotam_location.dart';

class ZipCodeSearchScreen extends StatefulWidget {
  const ZipCodeSearchScreen({super.key, required this.title});

  final String title;

  @override
  State<ZipCodeSearchScreen> createState() => _ZipCodeSearchScreenState();
}

class _ZipCodeSearchScreenState extends State<ZipCodeSearchScreen> {
  Country? _selectedCountry;
  String? _value;

  void getHttpInfo(String countryCode, String zip) async {
    final snackBar = SnackBar(
      content: Column(children: [
        Text("$countryCode $zip"),
        Text("Zippopotam URI"),
        Text(ZippopotamService.serviceUri(_selectedCountry!.code, zip)
            .toString()),
      ]),
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 12),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        DropDownCountries(
          selectionCallback: (selectedCountry) {
            setState(() {
              _selectedCountry = selectedCountry;
              _value = null;
            });
          },
        ),
        if (_selectedCountry != null)
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Center(child: Text(_selectedCountry!.country)),
                    Center(
                      child: Text("Range: ${_selectedCountry!.range}"),
                    ),
                    Center(
                      child: TextFieldValidated(
                        submitText: 'Submit',
                        textFieldStyle:
                            TextStyle(fontSize: 32.0, color: Colors.black87),
                        inputFormatter: (_selectedCountry!.regex != null)
                            ? ValidatorInputFormatter(
                                editingValidator: RegexValidator(
                                    regex: _selectedCountry!
                                        .editingRegexp(caseSensitive: false)),
                              )
                            : null,
                        submitValidator: RegexValidator(
                            regex:
                                _selectedCountry!.regexp(caseSensitive: false)),
                        onSubmit: (String value) {
                          setState(() {
                            _value = value;
                          });
                          getHttpInfo(_selectedCountry!.code, value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_value != null)
                ShowZippopotamLocation(
                  countryCode: _selectedCountry!.code,
                  postalCode: _value!,
                ),
            ],
          ),
      ]),
    );
  }
}
