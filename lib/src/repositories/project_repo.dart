import '../helpers/helper.dart';
import '../models/project.dart';
import '../models/project_media_library.dart';
import '../models/project_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../helpers/app_constants.dart' as constants;

const String _errorString = "Project Repo Error: ";

Future<Stream<Project>> getUserProjects() async {
  String url = "${constants.apiBaseUrl}client/getProjectRequest";
  print("URI For Getting User Projects: $url");

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
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
          print("printing projects data");
          // print(data);
          return Project.fromJSON(data);
        });
  } on SocketException {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(Project.fromJSON({}));
  }
}

Future<Project> createProject(Project project) async {
  String url = "${constants.apiBaseUrl}client/projectRequest";

  try {
    Uri uri = Uri.parse(url);
    var body = jsonEncode(project.toMap());
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
      body: body,
    );

    // print(body);

    print(response.statusCode);
    // print(json.decode(response.body));
    // Map responseBody = json.decode(response.body);
    // print(responseBody.containsKey("errors"));

    if (response.statusCode == 200 &&
        json.decode(response.body)['data'] != null) {
      print("project created successfully");
      return Project.fromJSON(json.decode(response.body)['data'][0]);
    } else {
      print("throws exception");
      throw Exception(response.body);
    }
    // return currentUser.value;
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Project.fromJSON({});
  }
}

Future<Stream<ProjectMediaLibrary>> addProjectMedia(
    List<ProjectMediaLibrary> mediaFiles, String projectId) async {
  String url = "${constants.apiBaseUrl}client/projectMediaLibraryRequest";

  try {
    Map<String, String> bodyMap = {
      "project_id": projectId,
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      // 'Accept': 'multipart/form-data',
      "Authorization": "Bearer ${Helper.getUserAuthToken()}",
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(bodyMap);
    request.headers.addAll(requestHeaders);

    if (mediaFiles.isNotEmpty) {
      // print("adding images");
      for (var mediaFile in mediaFiles) {
        // print("inside map loop");
        String imageType = mediaFile.imageFile!.path.split('.').last;
        var multiPartFile = await http.MultipartFile.fromPath(
          "image_url[]",
          mediaFile.imageFile!.path,
          contentType: MediaType("image", imageType),
        );
        request.files.add(multiPartFile);
      }
    }

    // print(request.fields);
    // print(request.files.length);

    var response = await request.send();

    print("URL For Adding Project Media: $url");
    print("${response.statusCode}");
    // print(response.toString());
    return response.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
      print(data);
      return Helper.getData(data as Map<String, dynamic>);
    }).expand((data) {
      print(data);
      return data as List;
    }).map((data) {
      print("printing project media lib data");
      print(data);
      return ProjectMediaLibrary.fromJSON(data);
    });
  } on SocketException catch (_) {
    print("Project Repo Socket Exception: ");
    throw const SocketException("Socket exception");
  } catch (e) {
    print("Error adding project media: $e");
    return Stream.value(ProjectMediaLibrary.fromJSON({}));
  }
}

Future<Stream<ProjectService>> addProjectServices(
    List<ProjectService> services, String projectId) async {
  String url = "${constants.apiBaseUrl}client/projectRequestService";
  List<Map> servicesJson = [];
  for (var service in services) {
    service.projectId = projectId;
    servicesJson.add(service.toMap());
  }
  var body = {"services": servicesJson};

  try {
    Uri uri = Uri.parse(url);
    final client = http.Client();

    var streamedRest = Stream.fromFuture(
      client.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
        },
        body: json.encode(body),
      ),
    );

    print("URL FOR ADDING PROJECT SERVICES: $url");
    // print(streamedRest.)

    return streamedRest.map((data) {
      print(data.body);
      print(data.statusCode);
      Map<String, dynamic> mapData = json.decode(data.body);
      return Helper.getData(mapData);
    }).expand((data) {
      // return data as List;
      return data;
    }).map((data) {
      print("printing project services data");
      // print(data);
      return ProjectService.fromJSON(data);
    });
  } catch (e) {
    print("Error adding project services: $e");
    return Stream.value(ProjectService.fromJSON({}));
  }
}

Future<Project> updateProjectStatus(String projectId, int status) async {
  String url = "${constants.apiBaseUrl}client/projectUpdate";
  Map<String, String> body = {
    "project_id": projectId,
    "status": status.toString()
  };
  Uri uri = Uri.parse(url);
  var jsonBody = jsonEncode(body);

  try {
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
      body: jsonBody,
    );

    // print(body);

    print(response.statusCode);
    // print(json.decode(response.body));
    // Map responseBody = json.decode(response.body);
    // print(responseBody.containsKey("errors"));

    if (response.statusCode == 200 &&
        json.decode(response.body)['data'] != null) {
      print("project status updated successfully");
      return Project.fromJSON(json.decode(response.body)['data'][0]);
    } else {
      print("throws exception");
      throw Exception(response.body);
    }
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Project.fromJSON({});
  }
}

Future<bool> deleteProject(String projectId) async {
  String url = "${constants.apiBaseUrl}client/project_destroy/$projectId";

  Uri uri = Uri.parse(url);
  final client = http.Client();
  try {
    final response = await client.delete(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Helper.getUserAuthToken()}'
      },
    );
    print("Deleting Project URL: $url");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("project deleted successfully");
      return true;
    } else {
      // print("throws exception");
      throw Exception(response.body);
    }
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return false;
  }
}
