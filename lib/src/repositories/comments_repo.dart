import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/project_comment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../helpers/app_constants.dart' as constants;

const String _errorString = "Comments Repo Error: ";

Future<ProjectComment> addProjectComment(ProjectComment comment) async {
  String url = "${constants.apiBaseUrl}client/project-comment";

  Map<String, String> requestHeaders = {
    'Content-type': 'multipart/form-data',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(comment.toMap());
    request.headers.addAll(requestHeaders);

    // adding image
    if (comment.imageFile != null) {
      print("adding image");
      String imageType = comment.imageFile!.path.split('.').last;
      request.files.add(
        await http.MultipartFile.fromPath("image_url", comment.imageFile!.path,
            contentType: MediaType("image", imageType)),
      );
    }

    var response = await request.send();
    //print("response: $response");

    var res = await http.Response.fromStream(response);

    print(response.statusCode);
    // print(res.body);
    Map jsonBody = json.decode(res.body);
    // print("json body: $jsonBody");
    //print("has errors: ${jsonBody.containsKey("errors")}");

    if (response.statusCode == 200) {
      return ProjectComment.fromJSON(jsonBody['data'][0]);
    } else {
      print("failed");
      return ProjectComment.fromJSON({});
      // throw Exception(res.body);
    }
    // return currentUser;
  } catch (e) {
    print("error caught");
    print(e);
    return ProjectComment.fromJSON({});
  }
}

Future<Stream<ProjectComment>> getProjectComment(String projectId,
    {required int skip, required int take}) async {
  Uri uri = Helper.getUri('client/getProjectComment/');
  Map<String, dynamic> queryParam = {
    'project_id': '' + projectId,
    'skip': '' + skip.toString(),
    'take': '' + take.toString()
  };

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${Helper.getUserAuthToken()}",
  };

  uri = uri.replace(queryParameters: queryParam);
  print("URL FOR Getting Project Comments " + uri.toString());

  final client = http.Client();

  try {
    // make request object with headers
    var request = http.Request('get', uri);
    request.headers.addAll(requestHeaders);

    final streamedRest = await client.send(request);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      print("returning data");
      // print(data);
      return ProjectComment.fromJSON(data);
    });
  } catch (e) {
    // print("error caught");
    print("$_errorString$e");
    return Stream.value(ProjectComment.fromJSON({}));
  }
}
