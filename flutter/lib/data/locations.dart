import 'package:latlong2/latlong.dart';

class RecyclingLocation {
  final String name;
  final LatLng coordinates;

  const RecyclingLocation({required this.name, required this.coordinates});
}

const List<RecyclingLocation> seedLocations = [
  RecyclingLocation(name: 'Vancouver Zero Waste Centre', coordinates: LatLng(49.208475, -123.115006)),
  RecyclingLocation(name: 'Mount Pleasant Return-It Express Depot', coordinates: LatLng(49.262680, -123.092770)),
  RecyclingLocation(name: 'Powell Street Return-It Express Depot', coordinates: LatLng(49.284426, -123.066404)),
  RecyclingLocation(name: 'Yaletown Return-It Express Depot', coordinates: LatLng(49.274152, -123.127196)),
  RecyclingLocation(name: 'Regional Recycling Vancouver Bottle Depot', coordinates: LatLng(49.270626, -123.081953)),
  RecyclingLocation(name: 'Eazy Return - Vancouver Return-It Depot', coordinates: LatLng(49.265044, -123.104525)),
  RecyclingLocation(name: 'Vancouver Central Return-It Express Depot', coordinates: LatLng(49.239215, -123.051404)),
  RecyclingLocation(name: 'South Van Bottle Depot', coordinates: LatLng(49.208822, -123.106361)),
  RecyclingLocation(name: 'Computie Electronics Recycling Depot', coordinates: LatLng(49.211124, -123.112212)),
  RecyclingLocation(name: 'Recycling Alternative', coordinates: LatLng(49.269673, -123.094286)),
];
