import 'package:arrant_construction_client/src/models/arrant_project.dart';
import 'package:arrant_construction_client/src/models/arrant_services.dart';
import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/vendor_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../helpers/app_constants.dart' as constants;

Future<Stream<ArrantServices>> getArrantServices() async {
  String url = "${constants.apiBaseUrl}getArrantServices";
  print("URI For Getting Arrant Services: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };
  try {
    Uri uri = Uri.parse(url);

    final client = http.Client();

    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing arrant services data");
          // print(data);
          return ArrantServices.fromJSON(data);
        });
  } on SocketException {
    print("General Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("error caught");
    print("General Repo Error: $e");
    return Stream.value(ArrantServices.fromJSON({}));
  }
}

Future<Stream<ArrantProject>> getArrantProjects() async {
  // Uri uri = Helper.getUri('');
  String url = "${constants.apiBaseUrl}getRecentProjects";
  print("URI For Getting Arrant Projects: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };
  try {
    Uri uri = Uri.parse(url);

    final client = http.Client();

    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          // print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing arrant projects data");
          // print(data);
          return ArrantProject.fromJSON(data);
        });
  } on SocketException {
    print("General Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("error caught");
    print("General Repo Error: $e");
    return Stream.value(ArrantProject.fromJSON({}));
  }
}

Future<Stream<VendorService>> getVendorServices() async {
  // Uri uri = Helper.getUri('');
  String url = "${constants.apiBaseUrl}getVendorServices";
  print("URI For Getting Vendor Services: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };
  try {
    Uri uri = Uri.parse(url);

    final client = http.Client();

    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          print(data);
          return Helper.getData(data as Map<String, dynamic>);
        })
        .expand((data) => (data as List))
        .map((data) {
          print("printing vendor services data");
          print(data);
          return VendorService.fromJSON(data);
        });
  } on SocketException {
    print("General Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("error caught");
    print("General Repo Error: $e");
    return Stream.value(VendorService.fromJSON({}));
  }
}
