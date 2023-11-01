import 'package:arrant_construction_client/src/controllers/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProjectCreatingBottomSheet extends StatelessWidget {
  // Project project;
  final String controllerTag;
  late ProjectController _con;
  ProjectCreatingBottomSheet(this.controllerTag, {Key? key}) : super(key: key) {
    _con = Get.find(tag: controllerTag);
  }

  @override
  Widget build(BuildContext context) {
    double containerRadius = 20.0;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.30,
        // width: 200,
        child: Column(
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //     onPressed: () {
            //       // prom
            //     },
            //     icon: Icon(
            //       Icons.cancel,
            //       color: Colors.red[800],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Requesting project: ${_con.project.name.capitalizeFirst}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            _multiProgressBar(context),
          ],
        ),
      ),
    );
  }

  Widget _multiProgressBar(BuildContext context) {
    Color progressIndicatorBG = Colors.grey;
    return Container(
      // color: Colors.black,
      // width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: progressIndicatorBG,
                    value: _con.donePostingProjectDetails.value ? 1 : null,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: progressIndicatorBG,
                    value: _con.donePostingProjectMedia.value ? 1 : null,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: progressIndicatorBG,
                    value: _con.donePostingProjectServices.value ? 1 : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            _con.donePostingProjectServices.value
                ? const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.done_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                  )
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
          ],
        );
      }),
    );
  }
}
