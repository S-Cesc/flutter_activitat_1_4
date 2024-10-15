import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_activitat_1_4/models/post_code.dart';
import '../services/zippopotam_service.dart';

class ShowZippopotamLocation extends StatelessWidget {
  const ShowZippopotamLocation(
      {super.key,
      required this.zippopotamService,
      required this.countryCode,
      required this.postalCode});

  final String countryCode;
  final String postalCode;
  final ZippopotamService zippopotamService; // = const ZippopotamService();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: zippopotamService.fetchData(countryCode, postalCode),
        builder: (BuildContext context, AsyncSnapshot<PostCode> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              children: [
                const Center(
                  child: Text("An error occurred while accessing the data."),
                ),
                Center(
                  child: Text(snapshot.error is HttpException
                      ? (snapshot.error! as HttpException).message
                      : snapshot.error.toString()),
                ),
              ],
            );
          } else if (snapshot.data != null &&
              snapshot.data!.places.isNotEmpty) {
            Iterable<Widget> places = snapshot.data!.places.map(
              (place) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("GEOPOSITION:"),
                        ),
                        Text(place.placeName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("(${place.state} - ${place.stateAbbreviation})"),
                        Text("coord: ${place.latitude}, ${place.longitude}"),
                        Divider(),
                      ]),
                ],
              ),
            );
            return Column(children: places.toList(growable: false));
          } else {
            return const Center(
              child: Text("Sense dades."),
            );
          }
        },
      ),
    );
  }
}
