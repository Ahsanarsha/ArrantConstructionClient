import 'package:arrant_construction_client/src/models/project.dart';
import 'package:arrant_construction_client/src/widgets/recent_project_card.dart';
import 'package:flutter/material.dart';

class RecentProjectsListWidget extends StatelessWidget {
  final List<Project> userRecentProjects;
  final Function onProjectClick;
  const RecentProjectsListWidget(this.userRecentProjects, this.onProjectClick,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(vertical: 10),
      // color: Colors.amber,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: userRecentProjects.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onProjectClick(userRecentProjects[index]);
              },
              child: RecentProjectCardWidget(userRecentProjects[index]),
            );
          }),
    );
  }
}
