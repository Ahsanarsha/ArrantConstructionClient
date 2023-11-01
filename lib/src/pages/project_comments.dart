import 'package:arrant_construction_client/src/controllers/comments_controller.dart';
import 'package:arrant_construction_client/src/widgets/showProjectsWidgets/project_comments_list.dart';
import '../controllers/project_controller.dart';
import '../widgets/loadingWidgets/loading_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;

class ProjectComments extends StatefulWidget {
  final String projectId;
  final CommentsController _con;
  const ProjectComments(this.projectId, this._con, {Key? key})
      : super(key: key);

  @override
  _ProjectCommentsState createState() => _ProjectCommentsState();
}

class _ProjectCommentsState extends State<ProjectComments> {
  // final CommentsController _con = Get.find(tag: constants.commentsConTag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await widget._con.refreshProjectComments(widget.projectId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                // const int numberOfCommentsOnMainPage = 2;
                return widget._con.projectComments.isEmpty &&
                        widget._con.doneFetchingProjectComments.value
                    ? const Center(child: Text("No comments"))
                    : widget._con.projectComments.isEmpty &&
                            !widget._con.doneFetchingProjectComments.value
                        ? LoadingCardWidget(
                            cardCount: 10,
                            width: MediaQuery.of(context).size.width * 0.90,
                            adjustment: BoxFit.fill,
                          )
                        : ProjectCommentsListWidget(
                            widget._con.projectComments);
              })
            ],
          ),
        ),
      ),
    );
  }
}
