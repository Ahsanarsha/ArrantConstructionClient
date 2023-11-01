import 'package:arrant_construction_client/src/models/project_service.dart';
import 'package:arrant_construction_client/src/widgets/projectRequestWidgets/project_service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProjectRequestAddedServicesList extends StatelessWidget {
  final List<ProjectService> services;
  final Function onDelete;
  const ProjectRequestAddedServicesList(this.services, this.onDelete,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100 * services.length.toDouble(),
      // color: Theme.of(context).primaryColor,
      // padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        itemCount: services.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ProjectRequestServiceTileWidget(
                services[index], index, onDelete),
          );
        },
      ),
    );
  }
}
