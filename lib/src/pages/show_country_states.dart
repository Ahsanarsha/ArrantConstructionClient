import 'package:arrant_construction_client/src/controllers/location_controller.dart';
import 'package:arrant_construction_client/src/widgets/listsWidgets/us_states_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowCountryStates extends StatefulWidget {
  final String country;
  const ShowCountryStates(this.country, {Key? key}) : super(key: key);

  @override
  _ShowCountryStatesState createState() => _ShowCountryStatesState();
}

class _ShowCountryStatesState extends State<ShowCountryStates> {
  final LocationController _con = Get.put(LocationController());

  void onStateSelect(String stateName) {
    Get.back(result: stateName);
  }

  @override
  void initState() {
    super.initState();
    _con.getCountryStates(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select State"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return _con.states.isEmpty && !_con.doneFetchingStates.value
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: CircularProgressIndicator(),
                    ))
                  : _con.states.isEmpty && _con.doneFetchingStates.value
                      ? Center(
                          child: _noStateFoundWidget(),
                        )
                      : UsStatesList(_con.states, onTap: onStateSelect);
            }),
          ],
        ),
      ),
    );
  }

  Widget _noStateFoundWidget() {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            _con.getCountryStates(widget.country);
          },
          icon: const Icon(Icons.refresh),
        ),
        const Text("Check internet connection and try agian"),
      ],
    );
  }
}
