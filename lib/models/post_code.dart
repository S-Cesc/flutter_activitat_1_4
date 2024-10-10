import 'dart:convert';

Map<String, dynamic> mapFromJson(String str) => jsonDecode(str);

class PostCode {
  String postCode;
  String country;
  String countryAbbreviation;
  List<Place> places;

  PostCode({
    required this.postCode,
    required this.country,
    required this.countryAbbreviation,
    required this.places,
  });

  factory PostCode.fromJson(Map<String, dynamic> jsonMap) => PostCode(
      postCode: jsonMap["post code"],
      country: jsonMap["country"],
      countryAbbreviation: jsonMap["country abbreviation"],
      places:
          List<Place>.from(jsonMap["places"].map((x) => Place.fromJson(x))));
  // json.decode(jsonMap["places"]).map((x) => Place.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "post code": postCode,
        "country": country,
        "country abbreviation": countryAbbreviation,
        "places": List<Map<String, dynamic>>.from(places.map((x) => x.toJson())),
      };
}

class Place {
  String placeName;
  String state;
  String stateAbbreviation;
  double latitude;
  double longitude;

  Place({
    required this.placeName,
    required this.longitude,
    required this.state,
    required this.stateAbbreviation,
    required this.latitude,
  });

  factory Place.fromJson(Map<String, dynamic> jsonMap) => Place(
        placeName: jsonMap["place name"],
        state: jsonMap["state"],
        stateAbbreviation: jsonMap["state abbreviation"],
        latitude: double.parse(jsonMap["latitude"]),
        longitude: double.parse(jsonMap["longitude"]),
      );

  Map<String, dynamic> toJson() => {
        "place name": placeName,
        "state": state,
        "state abbreviation": stateAbbreviation,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      };
}
