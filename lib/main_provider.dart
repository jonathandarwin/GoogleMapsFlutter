import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class MainProvider extends ChangeNotifier{  
  static const String API_KEY = 'AIzaSyBBYMBG7l5b3art73WSJ44DA1P521DkrGw';
  // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: API_KEY);

  String _address = '';
  Set<Marker> _marker = {};
  
  Set<Marker> get marker => _marker;  
  String get address => _address;

  Future<Map<String, double>> getCurrentLocation() async{
    loc.Location location = loc.Location();  
    return await location.getLocation();
  }
  set address(String address){
    this._address = address;    
  }  

  void addMarker(Map<String, double> data){    
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
  }

  void doSearch(BuildContext context) async {
    Map<String, double> location = await getCurrentLocation();
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: API_KEY,

    );        

    if(prediction != null){      
      List<Address> address = await Geocoder.local.findAddressesFromQuery(prediction.description);
      Coordinates coordinates = address.first.coordinates;      
      Map<String, double> data = {
        'latitude' : coordinates.latitude,
        'longitude' : coordinates.longitude
      };
      addMarker(data);
    }
  }
}