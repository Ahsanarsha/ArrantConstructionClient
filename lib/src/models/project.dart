import 'package:arrant_construction_client/src/models/project_manager.dart';
import 'package:arrant_construction_client/src/models/project_media_library.dart';
import 'package:arrant_construction_client/src/models/project_service.dart';

class Project {
  String? id;
  late String name;
  late String description;
  late String location;
  late String clientId;
  late String managerId;
  late String requestDate;
  late String estimatedStartDate;
  late String estimatedEndDate;
  late String backofficeComments;
  // 0 = request/project cancel
  // 1 = project requested by client & received by BO
  // 2 = BO sent estimated cost and time & received by client
  // 3 = Client accepted the estimates & BO is being notified
  late int status;
  late double estimatedCost;

  ProjectManager? manager;
  late List<ProjectMediaLibrary> mediaLibraryFiles;
  late List<ProjectService> addedServices;

  Project();

  Project.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      name = jsonMap['name'] ?? '';
      description = jsonMap['description'] ?? '';
      location = jsonMap['location'] ?? '';
      clientId =
          jsonMap['client_id'] != null ? jsonMap['client_id'].toString() : '';
      managerId = managerId =
          jsonMap['manager_id'] != null ? jsonMap['manager_id'].toString() : '';
      requestDate = jsonMap['request_date'] ?? '';
      estimatedStartDate = jsonMap['estimated_start_date'] ?? '';
      estimatedEndDate = jsonMap['estimated_end_date'] ?? '';
      backofficeComments = jsonMap['comment'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      estimatedCost = jsonMap['estimated_cost'] != null
          ? double.parse(jsonMap['estimated_cost'].toString())
          : 0.0;
      addedServices = jsonMap['project_services'] != null &&
              (jsonMap['project_services'] as List).isNotEmpty
          ? List.from(jsonMap['project_services'])
              .map((element) => ProjectService.fromJSON(element))
              .toList()
          : [];
      mediaLibraryFiles = jsonMap['project_media_library'] != null &&
              (jsonMap['project_media_library'] as List).isNotEmpty
          ? List.from(jsonMap['project_media_library'])
              .map((element) => ProjectMediaLibrary.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      print("Project Model Error: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['description'] = description;
    map['location'] = location;
    map['status'] = status.toString();
    return map;
  }
}
