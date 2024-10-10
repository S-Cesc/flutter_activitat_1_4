import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/post_code.dart';

class ZippopotamService {
  static Uri serviceUri(String countryCode, String postalCode) =>
      Uri.parse("http://api.zippopotam.us/$countryCode/$postalCode");
  
  const ZippopotamService();

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
