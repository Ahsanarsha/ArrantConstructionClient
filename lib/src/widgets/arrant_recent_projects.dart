import 'package:arrant_construction_client/src/models/arrant_project.dart';
import 'package:arrant_construction_client/src/widgets/arrant_project_card.dart';
import 'package:flutter/material.dart';

class ArrantRecentProjects extends StatelessWidget {
  final List<ArrantProject> arrantProjects;
  final Function onArrantProjectTap;
  const ArrantRecentProjects(this.arrantProjects, this.onArrantProjectTap,
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
          itemCount: arrantProjects.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onArrantProjectTap(arrantProjects[index]);
              },
              child: ArrantProjectCard(arrantProjects[index]),
            );
          }),
    );
  }
}
