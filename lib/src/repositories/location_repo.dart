import 'dart:convert';
import 'dart:io';
import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:http/http.dart' as http;
import '../helpers/app_constants.dart' as constants;

Future<Stream<String>> getCountryStates(String countryName) async {
  String url = constants.getCountryStateUrl;
  try {
    Map<String, String> body = {"country": countryName};
    Uri uri = Uri.parse(url);
    final client = http.Client();
    var request = http.Request('post', uri);
    // request.body = jsonEncode(body);
    request.bodyFields = body;
    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
      // print(data);
      return Helper.getData(data as Map<String, dynamic>);
    }).expand((data) {
      return (data["states"] as List);
    }).map((data) {
      // print("printing meals data");
      // print(data);
      return data["name"];
    });
  } on SocketException {
    print("Location Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("Location Repo Error caught: $e");
    return Stream.value('');
  }
}

Future<Stream<String>> getCountryStateCities(
    String countryName, String stateName) async {
  String url = constants.getStateCitiesUrl;
  try {
    Map<String, String> body = {"country": countryName, "state": stateName};
    Uri uri = Uri.parse(url);
    final client = http.Client();
    var request = http.Request('post', uri);
    // request.body = jsonEncode(body);
    request.bodyFields = body;
    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
      // print(data);
      return Helper.getData(data as Map<String, dynamic>);
    }).expand((data) {
      return (data as List);
    }).map((data) {
      // print("printing meals data");
      // print(data);
      return data;
    });
  } on SocketException {
    print("Location Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("Location Repo Error caught: $e");
    return Stream.value('');
  }
}
