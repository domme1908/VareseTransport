import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:varese_transport/constants.dart';
import 'package:http/http.dart' as http;
import 'package:varese_transport/lib/classes/itinerary.dart';
import 'package:varese_transport/screens/solutions/solutions_screen.dart';

import '../../../lib/classes/station.dart';
import '../../../lib/classes/stop.dart';

class APICall extends StatefulWidget {
  const APICall({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return APICallState();
  }
}

class APICallState extends State<APICall> {
  //These variables are used for the API call - they are updated from the body class
  static Station fromStation = Station.empty(), toStation = Station.empty();
  static String from = "null", to = "null", time = "", date = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      //Style the button
      margin: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: kSecondaryColor,
      ),
      //InkWell-> Rectangular area that responds to touch
      child: InkWell(
        //On botton click call API
        onTap: () {
          //Check if neccessary values have been given
          if (!(fromStation.station == "null") &&
              !(toStation.station == "null")) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SolutionsScreen()));
          } else {
            //Otherwise display a snackbar with the error message
            const errorMes = SnackBar(
              //Snackbar desing
              content: Text("Indicare partenza e destinazione!"),
              behavior: SnackBarBehavior.floating,
            );
            //Display the snackbar
            ScaffoldMessenger.of(context).showSnackBar(errorMes);
          }
        },
        //Further design of the button
        child: const SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(
              child: Text(
            'Cerca',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          )),
        ),
      ),
    );
  }

  //The api call - sends the collected values to the js rest api
  Future<List<Itinerary>> fetchItinerary() async {
    print("FETCHING SOLUTIONS");
    print('https://apidaqui-18067.nodechef.com/getSolutions?from=' +
        fromStation.station.replaceAll(RegExp('\\s'), '%20') +
        "&fromX=" +
        fromStation.x +
        "&fromY=" +
        fromStation.y +
        "&to=" +
        toStation.station.replaceAll(RegExp('\\s'), '%20') +
        "&toX=" +
        toStation.x +
        "&toY=" +
        toStation.y +
        "&date=" +
        date.replaceAll(".", "/") +
        "&when=" +
        time);
    //TODO URL must be changed to final value
    final response = await http.get(Uri.parse(
        'https://apidaqui-18067.nodechef.com/getSolutions?from=' +
            (fromStation.station != "Posizione"
                ? fromStation.station.replaceAll(RegExp('\\s'), '%20')
                : "La tua posizione") +
            "&fromX=" +
            fromStation.x +
            "&fromY=" +
            fromStation.y +
            "&to=" +
            toStation.station.replaceAll(RegExp('\\s'), '%20') +
            "&toX=" +
            toStation.x +
            "&toY=" +
            toStation.y +
            "&date=" +
            date.replaceAll(".", "/") +
            "&when=" +
            time));

    //Call the compute function provided by flutter
    return compute(
        parseItinerary,
        response
            .body); //--> We create an isolated element that eventually returns the value, thus the fetchItinerary() function must be async
  }

  List<Itinerary> parseItinerary(String responseBody) {
    //Parse the response to a JSON Map
    print(responseBody);

    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    //Execute the json-factory of class Itinerary on all elements in order to return a List<Itinerary>
    return parsed.map<Itinerary>((json) => Itinerary.fromJson(json)).toList();
  }

  Future<List<Station>> fetchStations([text]) async {
    print("Fetching stations for " + text);
    final response = await http.get(Uri.parse(
        'https://apidaqui-18067.nodechef.com/testStations?text=' + text));
    return compute(parseStations, response.body);
  }

  List<Station> parseStations(String responseBody) {
    //TODO HTTP STATUS CODES SWITCH
    if (responseBody.contains("error")) {
      return List<Station>.empty();
    }
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }

  List<Stop> parseStops(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Stop>((json) => Stop.fromJson(json)).toList();
  }
}
