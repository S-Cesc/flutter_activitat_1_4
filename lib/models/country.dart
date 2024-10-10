// To parse this JSON data, do
//
//     final countries = countryFromJson(jsonString);

import 'dart:convert';

  List<Country> countriesFromJson(String str) =>
      List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

  String countriesToJson(List<Country> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  String country;
  String code;
  String exampleUrl;
  String range;
  String? regex;
  String? editingRegex;
  int count;

  Country({
    required this.country,
    required this.code,
    required this.exampleUrl,
    required this.range,
    this.regex,
    this.editingRegex,
    required this.count,
  });

  RegExp? regexp({bool caseSensitive = false}) => RegExp("^$regex\$", caseSensitive: caseSensitive);
  RegExp? editingRegexp({bool caseSensitive = false}) => RegExp("^$editingRegex\$", caseSensitive: caseSensitive);

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["Country"],
        code: json["Code"],
        exampleUrl: json["Example URL"],
        range: json["Range"],
        regex: json["Regex"],
        editingRegex: json["EditingRegex"],
        count: json["Count"],
      );

  Map<String, dynamic> toJson() => {
        "Country": country,
        "Code": code,
        "Example URL": exampleUrl,
        "Range": range,
        "Regex": regex,
        "EditingRegex": editingRegex,
        "Count": count,
      };

}
