import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/project.dart';
import 'package:arrant_construction_client/src/models/project_comment.dart';
import 'package:arrant_construction_client/src/models/project_media_library.dart';
import 'package:arrant_construction_client/src/models/project_service.dart';
import 'package:arrant_construction_client/src/repositories/project_repo.dart'
    as project_repo;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProjectController extends GetxController {
  // fetching project variables
  var requestedProjects = <Project>[].obs;
  var projectsPendingApprovals = <Project>[].obs;
  var onGoingProjects = <Project>[].obs;

  // creating new project request variables
  Project project = Project();
  var projectRequestAddedServices = <ProjectService>[].obs;
  var projectMediaLibList = <ProjectMediaLibrary>[].obs;

  // Error string
  final String errorString = "Project Controller Error: ";

  // project fetching progress variables
  var doneFetchingUserProjects = false.obs;

  // project creating progress variables
  var donePostingProjectDetails = false.obs;
  var donePostingProjectMedia = false.obs;
  var donePostingProjectServices = false.obs;

  Future<void> getUserProjects() async {
    doneFetchingUserProjects.value = false;
    requestedProjects.clear();
    projectsPendingApprovals.clear();
    onGoingProjects.clear();
    Stream<Project> stream = await project_repo.getUserProjects();
    stream.listen((Project _p) {
      switch (_p.status) {
        case 1:
          {
            requestedProjects.add(_p);
          }
          break;
        case 2:
          {
            projectsPendingApprovals.add(_p);
          }
          break;
        case 3:
          {
            onGoingProjects.add(_p);
          }
          break;
        default:
          {
            print("project is null");
          }
          break;
      }
    }, onError: (e) {
      print(errorString + e);
    }, onDone: () {
      doneFetchingUserProjects.value = true;
    });
  }

  // step 1
  Future<void> createProject(BuildContext context) async {
    bool isSuccessful = false;
    donePostingProjectDetails.value = false;
    await project_repo.createProject(project).then((Project _p) {
      if (_p.id != null && _p.id!.isNotEmpty) {
        project = _p;
        isSuccessful = true;
      }
    }).onError((error, stackTrace) {
      isSuccessful = false;
      Fluttertoast.showToast(
          msg: "Failed requesting project. Check internet connection!");
      print(errorString + error.toString());
    }).whenComplete(() {
      if (isSuccessful) {
        donePostingProjectDetails.value = true;
        _addProjectMediaLib(context, project.id ?? '');
      }
    });
  }

  // step 2
  Future<void> _addProjectMediaLib(
      BuildContext context, String projectId) async {
    if (projectMediaLibList.isEmpty) {
      _addProjectServices(context, projectId);
    } else {
      bool isSuccessful = false;
      donePostingProjectMedia.value = false;
      Stream<ProjectMediaLibrary> stream =
          await project_repo.addProjectMedia(projectMediaLibList, projectId);
      // stream.asBroadcastStream().listen((event) { })
      stream.listen((ProjectMediaLibrary _mediaLib) {
        print(_mediaLib.id);
        isSuccessful = true;
      }, onError: (e) {
        isSuccessful = false;
        Fluttertoast.showToast(
            msg: "Failed requesting project. Check internet connection!");
        deleteProject(projectId);
        print("$errorString $e");
        Get.back();
      }, onDone: () {
        // call add_services func
        if (isSuccessful) {
          donePostingProjectMedia.value = true;
          _addProjectServices(context, projectId);
        } else {
          // abort project creation
          deleteProject(projectId);
          Fluttertoast.showToast(
              msg: "Failed requesting project. Check internet connection!");
          Get.back();
        }
      });
    }
  }

  // step 3
  Future<void> _addProjectServices(
      BuildContext context, String projectId) async {
    bool isSuccessful = false;
    donePostingProjectServices.value = false;
    Stream<ProjectService> stream = await project_repo.addProjectServices(
        projectRequestAddedServices, projectId);
    stream.listen((ProjectService _service) {
      print(_service.areaInSqM);
      isSuccessful = true;
    }, onError: (e) {
      isSuccessful = false;
      Fluttertoast.showToast(
          msg: "Failed requesting project. Check internet connection!");
      deleteProject(projectId);
      print("$errorString $e");
    }, onDone: () {
      // all done
      if (isSuccessful) {
        donePostingProjectServices.value = true;
        Future.delayed(const Duration(seconds: 2)).then((value) {
          Get.offAllNamed('/BottomNavPage/0');
        });
      } else {
        // abort creating project
        print("error adding services");
      }
    });
  }

  Future<bool> updateProjectStatus(
      BuildContext context, String projectId, int status) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    bool isUpdated = false;
    await project_repo
        .updateProjectStatus(projectId, status)
        .then((Project _p) {
      print(_p.id);
      if (_p.id!.isNotEmpty) {
        isUpdated = true;
        Fluttertoast.showToast(msg: "Project Accepted");
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
      Fluttertoast.showToast(msg: "Failed! Check internet connection");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
    return isUpdated;
  }

  Future<void> deleteProject(String projectId) async {
    await project_repo.deleteProject(projectId).then((value) {
      if (value) {
        print("project deleted successfully");
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
    }).whenComplete(() {});
  }

  Future<void> refreshProjects() async {
    getUserProjects();
  }
}
