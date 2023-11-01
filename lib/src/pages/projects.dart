import 'package:arrant_construction_client/src/controllers/project_controller.dart';
import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/project.dart';
import 'package:arrant_construction_client/src/pages/project_details.dart';
import 'package:arrant_construction_client/src/widgets/showProjectsWidgets/show_projects_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final ProjectController _con =
      Get.put(ProjectController(), tag: constants.projectsConTag);
  final List<Tab> _projectTypes = const [
    // project status 1
    Tab(
      text: "New",
    ),
    // project status 2
    Tab(
      text: "Pending Approval",
    ),
    // project status 3
    Tab(
      text: "On Going",
    ),
  ];

  void onProjectClick(Project project) async {
    bool isProjectAccepted = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectDetails(project);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (isProjectAccepted) {
      _con.refreshProjects();
    }
  }

  @override
  void initState() {
    super.initState();
    _con.getUserProjects();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _projectTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Projects"),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: _projectTypes,
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              return _con.requestedProjects.isEmpty &&
                      _con.doneFetchingUserProjects.value
                  ? _noProjectsToShow()
                  : _con.requestedProjects.isEmpty &&
                          !_con.doneFetchingUserProjects.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            return _con.refreshProjects();
                          },
                          child: ShowProjectsListWidget(
                            _con.requestedProjects,
                            onProjectClick,
                          ),
                        );
            }),
            Obx(() {
              return _con.projectsPendingApprovals.isEmpty &&
                      _con.doneFetchingUserProjects.value
                  ? _noProjectsToShow()
                  : _con.projectsPendingApprovals.isEmpty &&
                          !_con.doneFetchingUserProjects.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            return _con.refreshProjects();
                          },
                          child: ShowProjectsListWidget(
                            _con.projectsPendingApprovals,
                            onProjectClick,
                          ),
                        );
            }),
            Obx(() {
              return _con.onGoingProjects.isEmpty &&
                      _con.doneFetchingUserProjects.value
                  ? _noProjectsToShow()
                  : _con.onGoingProjects.isEmpty &&
                          !_con.doneFetchingUserProjects.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            return _con.refreshProjects();
                          },
                          child: ShowProjectsListWidget(
                            _con.onGoingProjects,
                            onProjectClick,
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }

  Widget _noProjectsToShow() {
    Text noProjectsTextWidget =
        const Text("No projects to show! Tap to refresh.");
    IconButton refreshButton = IconButton(
      onPressed: () {
        _con.refreshProjects();
      },
      icon: const Icon(Icons.refresh),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          refreshButton,
          noProjectsTextWidget,
        ],
      ),
    );
  }
}
