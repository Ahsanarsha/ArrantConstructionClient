import 'package:arrant_construction_client/src/controllers/location_controller.dart';
import 'package:arrant_construction_client/src/widgets/listsWidgets/us_states_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ShowStateCities extends StatefulWidget {
  final String country;
  final String state;
  const ShowStateCities(this.country, this.state, {Key? key}) : super(key: key);

  @override
  _ShowStateCitiesState createState() => _ShowStateCitiesState();
}

class _ShowStateCitiesState extends State<ShowStateCities> {
  final LocationController _con = Get.put(LocationController());

  void onCitySelect(String stateName) {
    Get.back(result: stateName);
  }

  @override
  void initState() {
    super.initState();
    _con.getStateCities(widget.country, widget.state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select City"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return _con.cities.isEmpty && !_con.doneFetchingCities.value
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: CircularProgressIndicator(),
                    ))
                  : _con.cities.isEmpty && _con.doneFetchingCities.value
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: _noCityFoundError(),
                          ),
                        )
                      : UsStatesList(_con.cities, onTap: onCitySelect);
            }),
          ],
        ),
      ),
    );
  }

  Widget _noCityFoundError() {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            _con.getStateCities(widget.country, widget.state);
          },
          icon: const Icon(Icons.refresh),
        ),
        const Text("Check internet connection and try agian"),
      ],
    );
  }
}
