import 'package:arrant_construction_client/src/models/project_comment.dart';
import 'package:arrant_construction_client/src/repositories/comments_repo.dart'
    as comments_repo;
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CommentsController {
  // project comment variables
  var projectComments = <ProjectComment>[].obs;

  // project comment fetching progress variables
  var doneFetchingProjectComments = false.obs;

  // Error string
  final String errorString = "Comments Controller Error: ";

  // @override
  // void onInit() {
  //   print("initializing comments controller");
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   print("disposing comments controller");
  //   super.onClose();
  // }

  Future<void> addProjectComment(ProjectComment projectComment) async {
    await comments_repo
        .addProjectComment(projectComment)
        .then((ProjectComment _c) {
          print(_c.time);
          projectComments.insert(0, _c);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }

  Future<void> getProjectComments(String projectId,
      {int skip = 0, int take = 10}) async {
    doneFetchingProjectComments.value = false;
    Stream<ProjectComment> stream = await comments_repo
        .getProjectComment(projectId, skip: skip, take: take);
    stream.listen((ProjectComment _comment) {
      print(_comment.id);
      if (_comment.isVisibleToClient == 1) {
        projectComments.add(_comment);
      }
    }, onError: (e) {
      print("$errorString $e");
    }, onDone: () {
      doneFetchingProjectComments.value = true;
    });
  }

  Future<void> refreshProjectComments(String projectId) async {
    projectComments.clear();
    await getProjectComments(projectId);
  }
}
