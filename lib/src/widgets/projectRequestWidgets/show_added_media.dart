import 'dart:io';
import 'package:arrant_construction_client/src/models/project_media_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProjectRequestAddedMediaWidget extends StatelessWidget {
  final ProjectMediaLibrary mediaItem;
  final int index;
  final Function onDelete;
  const ProjectRequestAddedMediaWidget(
      this.mediaItem, this.index, this.onDelete,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          image: FileImage(
            File(mediaItem.imageFile!.path),
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () {
                  onDelete(index);
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red[800],
                ),
              ))
        ],
      ),
    );
  }
}
