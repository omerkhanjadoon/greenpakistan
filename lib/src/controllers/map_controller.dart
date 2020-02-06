import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/helpers/maps_util.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/repository/nursery_repository.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart' as sett;
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MapController extends ControllerMVC {
  Nursery currentNursery;
  List<Nursery> topNursery = <Nursery>[];
  List<Marker> allMarkers = <Marker>[];
  LocationData currentLocation;
  Set<Polyline> polylines = new Set();
  CameraPosition cameraPosition;
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();

  MapController() {
    getCurrentLocation();
    getDirectionSteps();
  }

  void listenForNearNursery(
      LocationData myLocation, LocationData areaLocation) async {
    final Stream<Nursery> stream =
        await getNearNursery(myLocation, areaLocation);
    stream.listen((Nursery _nursery) {
      setState(() {
        topNursery.add(_nursery);
      });
      Helper.getMarker(_nursery.toMap()).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await sett.getCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(currentNursery.latitude),
              double.parse(currentNursery.longitude)),
          zoom: 14.4746,
        );
      });
      Helper.getMyPositionMarker(
              currentLocation.latitude, currentLocation.longitude)
          .then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.4746,
    )));
  }

  void getNurseryOfArea() async {
    setState(() {
      topNursery = <Nursery>[];
      LocationData areaLocation = LocationData.fromMap({
        "latitude": cameraPosition.target.latitude,
        "longitude": cameraPosition.target.longitude
      });
      if (cameraPosition != null) {
        listenForNearNursery(currentLocation, areaLocation);
      } else {
        listenForNearNursery(currentLocation, currentLocation);
      }
    });
  }

  String dp(String value, int places) {
    double val = double.parse(value);
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod).toString();
  }

  void getDirectionSteps() async {
    currentLocation = await sett.getCurrentLocation();
    String current_nursery_lat = currentNursery.latitude;
    print("my location : ");
    print(currentNursery.latitude.toString());
    mapsUtil
        .get("origin=" +
            dp(currentLocation.latitude.toString(), 7) +
            "," +
            dp(currentLocation.longitude.toString(), 7) +
            "&destination=" +
            dp(currentNursery.latitude, 7) +
            "," +
            dp(currentNursery.longitude, 7) +
            "&key=${GlobalConfiguration().getString('google_maps_key')}")
        .then((dynamic res) {
      print("res : ");
      print(res);
      List<LatLng> _latLng = res as List<LatLng>;
      _latLng.insert(
          0, new LatLng(currentLocation.latitude, currentLocation.longitude));
      setState(() {
        polylines.add(new Polyline(
            visible: true,
            polylineId: new PolylineId(currentLocation.hashCode.toString()),
            points: _latLng,
            color: Colors.green,
            width: 6));
      });
    });
  }

  Future refreshMap() async {
    setState(() {
      topNursery = <Nursery>[];
    });
    listenForNearNursery(currentLocation, currentLocation);
  }
}
