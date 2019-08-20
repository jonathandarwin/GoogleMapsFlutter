import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
          body: Body()
        ),
      ),
    );
  }
}

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    MainProvider _provider = Provider.of<MainProvider>(context, listen: false);

    return FutureBuilder(
      future: _provider.getCurrentLocation(),
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
    );
  }
}

class MyGoogleMaps extends StatelessWidget{
  final Map<String, double> data;
  MyGoogleMaps(this.data);

  final Completer<GoogleMapController> _controller = Completer();
  

  @override
  Widget build(BuildContext context){    
    MainProvider _provider = Provider.of<MainProvider>(context);
    _provider.addMarker(data);

    return Stack(
      children: <Widget>[
        // MAPS
        GoogleMap(
          markers: _provider.marker,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(data['latitude'], data['longitude']),
            zoom: 15
          ),
        ),
        // SEARCH
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // TEXT FIELD
                Expanded(    
                  flex: 2,              
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      onChanged: (text) => _provider.address = text,
                      decoration: InputDecoration(
                        labelText: 'Search'
                      ),
                    ),
                  ),
                ),
                // BUTTON
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _provider.doSearch(context),
                    child: Text('Search'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

