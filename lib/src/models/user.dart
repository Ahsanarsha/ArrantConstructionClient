// import 'package:arrant_construction_client/src/helpers/app_constants.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class User {
  // make sure late varibales are initialized
  // before you use them
  late String id;
  late String name;
  late String email;
  late String contactNumber;
  late String password;
  late String imageUrl;
  late String authToken;
  File? imageFile; // not for api

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      email = jsonMap['email'] ?? '';
      imageUrl = jsonMap['image_url'] ?? '';
      contactNumber = jsonMap['contact_no'] ?? '';
      authToken = jsonMap['access_token'] ?? '';
    } catch (e) {
      print("User Model Error: $e");
    }
  }

  Map toMap() {
    var map = <String, String>{};
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
