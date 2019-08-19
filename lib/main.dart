import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps/main_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      home: RootLayout(),
    );
  }
}

class RootLayout extends StatelessWidget {  
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      builder: (_) => MainProvider(),
      child: SafeArea(
        child: Scaffold(
          body: Consumer<MainProvider>(
            builder: (context, provider, _) => FutureBuilder(
              future: provider.getCurrentLocation(),
              initialData: null,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  Map<String, double> data = snapshot.data;
                  return MyGoogleMaps(data);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ),
      ),
    );
  }
}

class MyGoogleMaps extends StatelessWidget{
  final Map<String, double> data;
  MyGoogleMaps(this.data);

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = {};

  @override
  Widget build(BuildContext context){
    _marker.add(Marker(
        markerId: MarkerId(data['latitude'].toString() + data['longitude'].toString()),
        position: LatLng(data['latitude'], data['longitude']),
        infoWindow: InfoWindow(
          title: 'Your current location',
          snippet: 'This is your location'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
    );

    return GoogleMap(
      markers: _marker,
      onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
      },
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(data['latitude'], data['longitude']),
        zoom: 12
      ),
    );
  }
}