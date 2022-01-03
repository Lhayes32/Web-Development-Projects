import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  late String location; //location name for UI
  late String time; // the time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not

  WorldTime({ required this.location, required this.flag, required this.url});

  // For any instance that uses this function, wait until it's done then use the instance
  Future<void> getTime() async {

    try{
      // make the request
      Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      // get properties from json
      String datetime = data['datetime'];

      // get sign before offset and offset
      String offset = data['utc_offset'].substring(0,3);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);

      // check if sign before is a plus and work accordingly
      now = offset[0] == '+' ? now.add(Duration(hours: int.parse(offset.substring(1,3)))) : now.subtract(Duration(hours: int.parse(offset.substring(1,3))));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    }
    catch (e) {
      print(e);
      time = 'could not get time';
    }



  }
}