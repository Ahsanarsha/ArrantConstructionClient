import 'dart:convert';
import 'dart:io';
import 'package:arrant_construction_client/src/helpers/configurations.dart';
import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/app_constants.dart' as constants;

User currentUser = User();

Future<User> registerUser(User user) async {
  String url = "${Configurations.apipiBaseUrl()}client/register";
  try {
    Uri uri = Uri.parse(url);
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8'
      },
      body: json.encode(user.toMap()),
    );

    print(json.encode(user.toMap()));

    print(response.statusCode);
    print(response.body);
    Map responseBody = json.decode(response.body);
    print(responseBody.containsKey("errors"));

    if (response.statusCode == 200 && !responseBody.containsKey("errors")) {
      print("user registered");
      currentUser = User.fromJSON(json.decode(response.body)['data'][0]);
      // setCurrentUser(response.body);
      // currentUser.value = User.fromJSON(json.decode(response.body)['data'][0]);
      print("user created successfully");
    } else {
      print("throws exception");
      throw Exception(response.body);
    }
    return currentUser;
  } catch (e) {
    print("error caught");
    print(e);
    return currentUser;
  }
}

Future<User> login(User user) async {
  String url = "${Configurations.apipiBaseUrl()}client/login";
  print("Login Url: $url");
  var body = {
    "email": user.email,
    "password": user.password,
  };
  print(body);
  try {
    Uri uri = Uri.parse(url);
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8'
      },
      body: json.encode(body),
    );
    print(response.statusCode);
    print(response.body);

    Map jsonBody = json.decode(response.body);
    if (response.statusCode == 200 &&
        jsonBody['data'][0]['access_token'] != null) {
      setCurrentUserInSP(response.body);
      currentUser = User.fromJSON(json.decode(response.body)['data'][0]);

      // return currentUser;
    } else {
      print("throws exception");
      // return currentUser;
    }
    return currentUser;
  } catch (e) {
    print("error caught");
    print(e.toString());
    return currentUser;
  }
}

Future<User> updateUser(User user) async {
  String url = "${constants.apiBaseUrl}client/profile/update";

  Map<String, String> body = {
    "name": user.name,
    "email": user.email,
    "contact_no": user.contactNumber,
  };

  Map<String, String> requestHeaders = {
    'Content-type': 'multipart/form-data',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    request.headers.addAll(requestHeaders);

    // adding image
    if (user.imageFile != null) {
      print("adding image");
      String imageType = user.imageFile!.path.split('.').last;
      request.files.add(
        await http.MultipartFile.fromPath("image_url", user.imageFile!.path,
            contentType: MediaType("image", imageType)),
      );
    }

    var response = await request.send();
    //print("response: $response");

    var res = await http.Response.fromStream(response);

    print(response.statusCode);
    // print(res.body);
    Map jsonBody = json.decode(res.body);
    //print("json body: $jsonBody");
    //print("has errors: ${jsonBody.containsKey("errors")}");

    if (response.statusCode == 200 &&
        jsonBody['data'][0]['access_token'] != null) {
      setCurrentUserInSP(res.body);
      print("user updated successfully");
      return User.fromJSON(jsonBody['data'][0]);
    } else {
      print("no updated");
      return User.fromJSON({});
      // throw Exception(res.body);
    }
    // return currentUser;
  } catch (e) {
    print("error updating user caught");
    print(e);
    return User.fromJSON({});
  }
}

void setCurrentUserInSP(jsonString) async {
  print("setting current user in SF");
  if (json.decode(jsonString)['data'][0] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userObject = json.decode(jsonString)['data'][0];
    await prefs.setString('current_user', json.encode(userObject));
    print("user saved in SP");
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("current_user")) {
    print("User Repo: user found from shared prefs");
    // print(prefs.get("current_user"));
    currentUser = User.fromJSON(
      json.decode(prefs.get("current_user").toString()),
    );
  } else {
    print("User Repo: user not found from shared prefs");
    currentUser = User.fromJSON({});
  }
  return currentUser;
}

Future<bool> removeCurrentUser() async {
  // reset user object
  currentUser = User.fromJSON({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // remove data
  try {
    await prefs.remove('current_user');
    await prefs.remove(constants.usStatesSPkey);
    print("User Repo: user data removed successfully");
    return true;
  } catch (e) {
    print("User Repo error: $e");
    return false;
  }
}
