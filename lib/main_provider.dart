import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

class MainProvider extends ChangeNotifier{  
  static const String API_KEY = 'AIzaSyBBYMBG7l5b3art73WSJ44DA1P521DkrGw';
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
    _marker.clear();
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
    
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: API_KEY);

    if(prediction != null){
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);      
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      var address = await Geocoder.local.findAddressesFromQuery(prediction.description);

      print('Prediction Description : ' + prediction.description);
      print(address);
      print('Lang : ' + lat.toString());      
      print('Long : ' + lng.toString());
    }
  }
}