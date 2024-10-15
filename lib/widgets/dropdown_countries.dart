import 'package:flutter/material.dart';
import '../models/country.dart';

class DropDownCountries extends StatefulWidget {
  const DropDownCountries({
    super.key,
    required this.getCountries,
    this.selectionCallback,
  });

  final void Function(Country? selectedCountry)? selectionCallback;
  final Future<List<Country>> Function() getCountries;

  @override
  State<DropDownCountries> createState() => _DropDownCountriesState();
}

class _DropDownCountriesState extends State<DropDownCountries> {
  late TextEditingController _menuController;
  late IconButton? _activeIcon;

  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    _menuController = TextEditingController();
    selectedCountry = null;
    _menuController.addListener(() {
      if (selectedCountry != null &&
          selectedCountry!.country != _menuController.text) {
        selectedCountry = null;
        if (widget.selectionCallback != null) {
          widget.selectionCallback!(null);
        }
      }
    });
  }

  void _clear() {
    _menuController.text = "";
    // Aqusta acció provocarà l'acció del listener i probablement un setState
  }

  @override
  Widget build(BuildContext context) {
    if (_menuController.text.isEmpty) {
      _activeIcon = null;
    } else {
      _activeIcon = IconButton(onPressed: _clear, icon: Icon(Icons.delete));
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: FutureBuilder(
              future: widget.getCountries(),
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
                    controller: _menuController,
                    leadingIcon: _activeIcon,
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
                      if (widget.selectionCallback != null) {
                        widget.selectionCallback!(country);
                      }
                    },
                    dropdownMenuEntries:
                        snapshot.data!.map<DropdownMenuEntry<Country>>((c) {
                      return DropdownMenuEntry<Country>(
                        value: c,
                        label: c.text,
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
    _menuController.dispose();
    super.dispose();
  }
}
