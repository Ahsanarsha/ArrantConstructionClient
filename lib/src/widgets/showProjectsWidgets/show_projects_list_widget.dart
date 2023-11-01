import 'package:arrant_construction_client/src/models/project.dart';
import 'package:arrant_construction_client/src/widgets/showProjectsWidgets/project_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowProjectsListWidget extends StatelessWidget {
  final List<Project> projects;
  final Function onTap;
  const ShowProjectsListWidget(this.projects, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ProjectListTileWidget(
            projects[index],
            onTap,
          ),
        );
      },
    );
  }
}
