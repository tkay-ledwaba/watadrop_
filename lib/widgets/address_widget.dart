import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:watadrop/cart/views/cart_screen.dart';
import 'package:watadrop/common/google_config.dart';
import 'package:watadrop/common/location_services.dart';
import 'package:watadrop/home/views/home_screen.dart';
import 'package:watadrop/widgets/custom_snackbar.dart';

import '../common/style.dart';

showAddressPickerDialog(context, addressController){
  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    getAddress(lat, lng).then((value) =>
    addressController.text = value
    );

  }

  void onError(PlacesAutocompleteResponse response){

    showCustomSnackBar(context, response.errorMessage, colorFailed);
  }

  final Mode _mode = Mode.overlay;

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country,"za")]);

    displayPrediction(p!,cartScaffoldKey.currentState);
  }

  _handlePressButton();
}