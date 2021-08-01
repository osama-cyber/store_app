import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:yagot_app/utilities/custom_icons.dart';
import 'package:yagot_app/utilities/helper_functions.dart';

class AddNewAddress extends StatefulWidget {
  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  Completer<GoogleMapController> _mapController = Completer();
  final  markers = <Marker>{};
  BitmapDescriptor markerIcon ;

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context)
        , "assets/images/location_on1.png",
    ).then((icon) {
      markerIcon = icon ;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          GoogleMap(

            onMapCreated: (GoogleMapController googleMapController) {
                _mapController.complete(googleMapController);
            },
            onTap: (latLng) async {
              GoogleMapController mapController = await _mapController.future ;
              mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 18));
              setState(() {
                _createMarker(mapController, latLng );
              });
            },
            initialCameraPosition:
                CameraPosition(zoom: 15.0, target: LatLng(31.5, 34.46667)),
            mapType: MapType.satellite,
            zoomControlsEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            markers: markers,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              SearchMapPlaceWidget(
                hasClearButton: true,
                placeType: PlaceType.address,
                placeholder: getTranslated(context,"look_for_your_location"),
                icon: CustomIcons.search,
                iconColor: Color(0xFF00041D),
                apiKey: 'AIzaSyBUILBxCa5yyQZawAAOpD6HII48R3haimM',
                onSelected: (Place place) async {
                  Geolocation geolocation = await place.geolocation;
                  GoogleMapController mapController = await _mapController.future ;
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(geolocation.coordinates));
                  mapController.animateCamera(
                      CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  _currentLocation();
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.16),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                            spreadRadius: 2)
                      ]),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.location_searching_rounded,
                        color: Color(0xFF00041D),
                        size: 30,
                      ),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * .9,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    getTranslated(context,"submit_address"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),

              ),
              SizedBox(height: 65),
            ],
          ),
        ],
      ),
    );
  }
  Widget _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
          getTranslated(context,"add_new_address")),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Color(0xFF00041D),
        ),
      ),
    );
  }

   _createMarker(GoogleMapController controller ,LatLng latLng ){
    LatLng markerLatLng = latLng ;
    markers.add(Marker(
      markerId: MarkerId("0"),
      position: markerLatLng,
      icon: markerIcon,
      onTap: (){
          controller.showMarkerInfoWindow(MarkerId("0"));
     },
     infoWindow: InfoWindow(title: markerLatLng.toString()),
     draggable: true ,
     onDragEnd: (endLatLang){
        setState(() {
          markerLatLng = endLatLang ;
        });
      },
    ));
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    LatLng latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: latLng,
        zoom: 17.0,
      ),
    ));
    setState(() {
      _createMarker(controller, latLng);
    });
  }
}
