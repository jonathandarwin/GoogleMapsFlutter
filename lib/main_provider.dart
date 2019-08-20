import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;

class MainProvider extends ChangeNotifier{  
  static const String API_KEY = 'AIzaSyBBYMBG7l5b3art73WSJ44DA1P521DkrGw';

  String _address = '';
  Set<Marker> _marker = {};
  LatLng _center;
  LatLng _lastPosition;
  
  Set<Marker> get marker => _marker;  
  String get address => _address;
  LatLng get center => _center;
  LatLng get lastPosition => _lastPosition;

  Future<int> initData() async {
    Map<String, double> data = await getCurrentLocation();
    _center = LatLng(data['latitude'], data['longitude']);
    return 1;
  }

  Future<Map<String, double>> getCurrentLocation() async{
    loc.Location location = loc.Location();  
    Map<String, double> data = await location.getLocation();
    addMarker(data);
    return data;   
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
    notifyListeners();
  }

  void cameraMove(CameraPosition position){
    _lastPosition = position.target;
  }

  void doSearch(BuildContext context) async {    
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: API_KEY,
      radius: 10000000,
      language: 'id'      
    );

    // CLEAR AND ADD MY LOCATION
    _marker.clear();
    Map<String, double> location = await getCurrentLocation();

    if(prediction != null){      
      List<Address> address = await Geocoder.local.findAddressesFromQuery(prediction.description);
      Coordinates coordinates = address.first.coordinates;      
      Map<String, double> data = {
        'latitude' : coordinates.latitude,
        'longitude' : coordinates.longitude
      };

      // SET NEW CENTER
      _center = LatLng(data['latitude'], data['longitude']);
      // SET NEW MARKER     
      addMarker(data);
      notifyListeners();
    }
    else{
      _center = LatLng(location['latitude'], location['longitude']);
      notifyListeners();
    }
  }

  void getAddress(LatLng position) async {
    Coordinates coor = Coordinates(position.latitude, position.longitude);
    List<Address> address = await Geocoder.local.findAddressesFromCoordinates(coor);
    print('Country : ' + address.first.countryName);
    print('Address : ' + address.first.addressLine);    
  }
}