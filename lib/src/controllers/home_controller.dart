import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/arrant_project.dart';
import 'package:arrant_construction_client/src/models/arrant_services.dart';
import 'package:arrant_construction_client/src/models/project.dart';
import 'package:arrant_construction_client/src/models/vendor_service.dart';
import 'package:arrant_construction_client/src/repositories/general_repo.dart'
    as general_repo;
import 'package:arrant_construction_client/src/repositories/project_repo.dart'
    as project_repo;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var arrantServices = <ArrantServices>[].obs;
  var arrantProjects = <ArrantProject>[].obs;
  List<VendorService> vendorServices = <VendorService>[];

  // on going projects
  var userOnGoingProjects = <Project>[].obs;

  // progress variables
  var doneFetchingArrantServices = false.obs;
  var doneFetchingArrantProjects = false.obs;
  var doneFetchingOnGoingProjects = false.obs;

  // error string
  String errorString = "Home Controller Error: ";

  Future<void> getArrantServices() async {
    doneFetchingArrantServices.value = false;
    Stream<ArrantServices> stream = await general_repo.getArrantServices();
    stream.listen((ArrantServices service) {
      print(service.imageUrl);
      arrantServices.add(service);
    }, onError: (e) {
      print("$errorString$e");
    }, onDone: () {
      doneFetchingArrantServices.value = true;
    });
  }

  Future<void> getArrantProjects() async {
    doneFetchingArrantProjects.value = false;
    Stream<ArrantProject> stream = await general_repo.getArrantProjects();
    stream.listen((ArrantProject _project) {
      arrantProjects.add(_project);
    }, onError: (e) {
      print("$errorString$e");
    }, onDone: () {
      doneFetchingArrantProjects.value = true;
    });
  }

  Future<void> getVendorServices() async {
    Stream<VendorService> stream = await general_repo.getVendorServices();
    stream.listen((VendorService _service) {
      vendorServices.add(_service);
    }, onError: (e) {
      print("$errorString$e");
      Fluttertoast.showToast(msg: "No internet connection!");
    }, onDone: () {
      Helper.setVendorServices(vendorServices);
    });
  }

  Future<void> getUserOnGoingProjects() async {
    doneFetchingOnGoingProjects.value = false;
    Stream<Project> stream = await project_repo.getUserProjects();
    stream.listen((Project _p) {
      if (_p.status == 3) {
        userOnGoingProjects.add(_p);
      }
    }, onError: (e) {
      print("$errorString$e");
    }, onDone: () {
      doneFetchingOnGoingProjects.value = true;
    });
  }
}
