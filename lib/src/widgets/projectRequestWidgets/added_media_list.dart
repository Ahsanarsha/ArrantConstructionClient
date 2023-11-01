import 'package:arrant_construction_client/src/models/project_media_library.dart';
import 'package:arrant_construction_client/src/widgets/projectRequestWidgets/show_added_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProjectRequestAddedMediaList extends StatelessWidget {
  final List<ProjectMediaLibrary> mediaList;
  // final int index;
  final Function onDelete;
  const ProjectRequestAddedMediaList(this.mediaList, this.onDelete, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: mediaList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (context, index) {
          return ProjectRequestAddedMediaWidget(
            mediaList[index],
            index,
            onDelete,
          );
        });
  }
}
