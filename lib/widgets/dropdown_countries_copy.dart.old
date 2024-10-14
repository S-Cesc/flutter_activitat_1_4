import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/country.dart';

class DropDownCountries extends StatefulWidget {
  const DropDownCountries({super.key, this.selectionCallback});

  final void Function(Country? selectedCountry)? selectionCallback;

  @override
  State<DropDownCountries> createState() => _DropDownCountriesState();
}

class _DropDownCountriesState extends State<DropDownCountries> {
  late TextEditingController menuController;
  late List<Country> lstCountries;
  bool initCountries = true;
  bool ps = true;
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    menuController = TextEditingController();
    selectedCountry = null;
    menuController.addListener(() {
      if (menuController.text.isEmpty && !ps) {
        ps = true;
        setState(() {
          selectedCountry = null;
          widget.selectionCallback!(null);
        });
      } else {
        ps = false;
        if (selectedCountry != null &&
            selectedCountry!.country != menuController.text) {
          setState(() {
            selectedCountry = null;
            widget.selectionCallback!(null);
          });
        }
      }
    });
  }

  void _clear() {
    menuController.text = "";
    // Aqusta acció provocarà l'acció del listener i un setState
  }

  Future<List<Country>> getCountries() async {
    if (initCountries) {
      var jsonString = await rootBundle.loadString("assets/data/csvjson.json");
      lstCountries = countriesFromJson(jsonString);
      lstCountries.sort((c1, c2) => c1.code.compareTo(c2.code));
      initCountries = false;
    }
    return lstCountries;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: FutureBuilder(
              future: getCountries(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Country>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("S'ha produit un error accedint a les dades."),
                  );
                } else if (snapshot.data != null) {
                  return DropdownMenu<Country>(
                    controller: menuController,
                    leadingIcon: (menuController.text.isNotEmpty)
                        ? IconButton(
                            onPressed: _clear, icon: Icon(Icons.delete))
                        : null,
                    label: const Text('Select country'),
                    hintText: "Select Menu",
                    requestFocusOnTap: true,
                    enableFilter: true,
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Colors.lightBlue.shade50),
                    ),
                    menuHeight: 300,
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      constraints:
                          BoxConstraints.tight(const Size.fromHeight(40)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    initialSelection: null,
                    onSelected: (Country? country) {
                      setState(() {
                        selectedCountry = country;
                      });
                      widget.selectionCallback!(country);
                    },
                    dropdownMenuEntries:
                        snapshot.data!.map<DropdownMenuEntry<Country>>((c) {
                      return DropdownMenuEntry<Country>(
                        value: c,
                        label: c.country,
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: Text("Sense dades."),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }
}
