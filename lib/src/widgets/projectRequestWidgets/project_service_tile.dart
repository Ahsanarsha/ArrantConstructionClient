import 'package:arrant_construction_client/src/models/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class ProjectRequestServiceTileWidget extends StatelessWidget {
  final ProjectService service;
  final int listIndex;
  final Function onDelete;
  const ProjectRequestServiceTileWidget(
      this.service, this.listIndex, this.onDelete,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconButton deleteButton = IconButton(
      onPressed: () {
        onDelete(listIndex);
      },
      icon: Icon(
        Icons.delete,
        color: Colors.red[800],
        size: 30,
      ),
    );
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _InternalTileClass(service),
        ),
        Expanded(
          flex: 1,
          child: deleteButton,
        ),
      ],
    );
  }

  // Widget _serviceTile(BuildContext context) {
  //   Color textColor = Colors.white;
  //   return
  // }
}

class _InternalTileClass extends StatelessWidget {
  final ProjectService service;
  const _InternalTileClass(this.service, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    return ListTile(
      tileColor: Theme.of(context).primaryColor,
      isThreeLine: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      title: Text(
        "${service.name}",
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${service.description}",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
        ),
      ),
      trailing: Text(
        "${service.areaInSqM} m${constants.squareSC}",
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
