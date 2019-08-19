import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class MainProvider extends ChangeNotifier{
  Future<Map<String, double>> getCurrentLocation() async{
    Location location = Location();  
    return await location.getLocation();
  }
}