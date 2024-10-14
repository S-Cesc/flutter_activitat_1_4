import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/post_code.dart';
import '../models/country.dart';

class ZippopotamService {
  static Uri serviceUri(String countryCode, String postalCode) =>
      Uri.parse("http://api.zippopotam.us/$countryCode/$postalCode");

  static final ZippopotamService _instance = ZippopotamService._internal();

  factory ZippopotamService() {
    return _instance;
  }

  ZippopotamService._internal() : _data = _getCountries();

  final Future<List<Country>> _data;

  // list of countries ZippopotamService accepts
  static Future<List<Country>> _getCountries() async {
    var jsonString = await rootBundle.loadString("assets/data/csvjson.json");
    List<Country> lstCountries;
    lstCountries = countriesFromJson(jsonString);
    lstCountries.sort((c1, c2) => c1.code.compareTo(c2.code));
    return lstCountries;
  }

  Future<List<Country>> getCountries() {
    return _data;
  }

  Future<PostCode> fetchData(String countryCode, String postalCode) async {
    countryCode = countryCode.toLowerCase();
    Uri uri = serviceUri(countryCode, postalCode);
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }
      final Map<String, dynamic> jsonPostCodeMap = mapFromJson(response.body);
      return PostCode.fromJson(jsonPostCodeMap);
    } on SocketException {
      throw SocketException('No Internet connection 😑');
    } on HttpException {
      throw HttpException("Couldn't find the post 😱");
    } on FormatException {
      throw FormatException("Bad response format 👎");
    }
  }
}
