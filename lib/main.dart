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
          appBar: AppBar(
            title: Text("Maps"),
            actions: <Widget>[
              IconSearch()
            ],
          ),
          body: Body(),
          floatingActionButton: ButtonAdd(),
        ),
      ),
    );
  }
}

class IconSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    MainProvider _provider = Provider.of<MainProvider>(context, listen:false);
    return GestureDetector(
      // onTap: () => _provider.doSearch(context),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(
          Icons.search,
          color: Colors.white
        ),
      ),
    );
  }
}

class ButtonAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    MainProvider _provider = Provider.of<MainProvider>(context, listen:false);

    return FloatingActionButton(
      onPressed: () {        
        Map<String, double> data = {
          'latitude' : _provider.lastPosition.latitude,
          'longitude' : _provider.lastPosition.longitude
        };        
        _provider.addMarker(data);
        _provider.getAddress(_provider.lastPosition);
      },
      child: Icon(Icons.add),
    );
  }
}

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    MainProvider _provider = Provider.of<MainProvider>(context, listen: false);

    return FutureBuilder(
      future: _provider.initData(),
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){          
          return MyGoogleMaps();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MyGoogleMaps extends StatelessWidget{
  final Completer<GoogleMapController> _controller = Completer();
  

  @override
  Widget build(BuildContext context){    
    MainProvider _provider = Provider.of<MainProvider>(context);    

    return Stack(
      children: <Widget>[
        // MAPS
        GoogleMap(
          markers: _provider.marker,
          onCameraMove: _provider.cameraMove,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _provider.center,
            zoom: 15
          ),
        ),
        Center(
          child: Icon(
            Icons.control_point,
            size: 50.0,
          ),
        )
      ],
    );
  }
}

