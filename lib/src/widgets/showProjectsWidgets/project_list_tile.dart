import 'package:arrant_construction_client/src/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProjectListTileWidget extends StatelessWidget {
  final Project project;
  final Function onClick;
  final bool showDescription;
  const ProjectListTileWidget(
    this.project,
    this.onClick, {
    Key? key,
    this.showDescription = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      // fontSize: 20,
    );
    return ListTile(
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      // if description is to be shown
      // then 3 lines otherwise not
      isThreeLine: showDescription,
      title: Text(
        project.name,
        style: titleStyle,
      ),
      subtitle: _subtitleWidget(),
      trailing: _trailingWidget(context),
      onTap: () {
        onClick(project);
      },
    );
  }

  Widget _subtitleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.requestDate),
        const SizedBox(
          height: 5.0,
        ),
        showDescription
            ? Text(
                project.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            : const SizedBox(
                width: 0.0,
                height: 0.0,
              ),
      ],
    );
  }

  Widget _trailingWidget(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Expanded(
            child: Icon(
              Icons.place,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              project.location,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrailingWidget extends StatelessWidget {
  final int status;
  const _TrailingWidget(this.status, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle statusStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );
    return SizedBox(
      width: 80,
      // height: 100,
      child: Column(
        children: [
          Expanded(
            child: Text(
              "Status",
              style: statusStyle,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _progressContainer(status > 0 ? true : false),
                ),
                const Expanded(
                  child: Divider(
                    // height: 3,
                    thickness: 2,
                    // color: Colors.black,
                  ),
                ),
                Expanded(
                  child: _progressContainer(status > 1 ? true : false),
                ),
                const Expanded(
                  child: Divider(
                    // height: 3,
                    thickness: 2,
                    // color: Colors.black,
                  ),
                ),
                Expanded(
                  child: _progressContainer(status > 2 ? true : false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressContainer(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
