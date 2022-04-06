import 'stop.dart';

//This class saves all the relevant data from each individual section of a given itinerary
class Section {
  var id;
  String duration;
  String line;
  String description;
  String departure;
  String departureTime;
  String arrival;
  String arrivalTime;
  String note;
  String xDeparture;
  String xArrival;
  String yDeparture;
  String yArrival;
  List<Stop> stops;
  //The firm that operates this line if "" walking
  String manager;
  Section(
      this.id,
      this.duration,
      this.line,
      this.description,
      this.departure,
      this.departureTime,
      this.arrival,
      this.arrivalTime,
      this.note,
      this.xDeparture,
      this.xArrival,
      this.yDeparture,
      this.yArrival,
      this.stops,
      [this.manager = "none"]);
  //Create a section instance from a JSON string
  factory Section.fromJson(dynamic json) {
    //Parse the list of stops and save them temporarily
    var stopsObsJson = json["stops"] as List;
    List<Stop> _stops =
        stopsObsJson.map((stopsObj) => Stop.fromJson(stopsObj)).toList();
    //Distinguish walking and other forms of transportation
    if (json.containsKey("manager")) {
      //This one is for bus, train, etc.
      return Section(
          int.parse(json['id']),
          json["duration"] as String,
          json["line"] as String,
          json["transportDescription"] as String,
          json["departure"] as String,
          json["departureTime"] as String,
          json["arrival"] as String,
          json["arrivalTime"] as String,
          json["note"] as String,
          json["xDeparture"] as String,
          json["xArrival"] as String,
          json["yDeparture"] as String,
          json["yArrival"] as String,
          _stops,
          json["manager"] as String);
    }
    //This one is for walking
    return Section(
        int.parse(json['id']),
        json["duration"] as String,
        json["line"] as String,
        json["transportDescription"] as String,
        json["departure"] as String,
        json["departureTime"] as String,
        json["arrival"] as String,
        json["arrivalTime"] as String,
        json["note"] as String,
        json["xDeparture"] as String,
        json["xArrival"] as String,
        json["yDeparture"] as String,
        json["yArrival"] as String,
        _stops);
  }
}
