import 'package:arrant_construction_client/src/models/vendor_service.dart';

class ProjectService {
  String? id;
  String? name; // self added field, not included in api
  String? projectId;
  String? serviceId; // main vendor service id
  String? description;
  int? status;
  double? areaInSqM;
  VendorService? service;

  ProjectService();

  ProjectService.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      projectId =
          jsonMap['project_id'] != null ? jsonMap['project_id'].toString() : '';
      serviceId =
          jsonMap['service_id'] != null ? jsonMap['service_id'].toString() : '';
      description = jsonMap['description'] ?? '';
      status = jsonMap['status'] != null
          ? int.parse(jsonMap['status'].toString())
          : 0;
      areaInSqM = jsonMap['area_sqm'] != null
          ? double.parse(jsonMap['area_sqm'].toString())
          : 0.0;
      service = jsonMap['vendor_service'] != null
          ? VendorService.fromJSON(jsonMap['vendor_service'][0])
          : VendorService.fromJSON({});
    } catch (e) {
      print("Project Service Model Error: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['project_id'] = projectId;
    map['service_id'] = serviceId;
    map['area_sqm'] = areaInSqM.toString();
    map['description'] = description ?? '';
    return map;
  }
}
