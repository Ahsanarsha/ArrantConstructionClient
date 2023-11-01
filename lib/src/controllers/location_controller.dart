import 'package:arrant_construction_client/src/repositories/location_repo.dart'
    as location_repo;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/app_constants.dart' as constants;

class LocationController extends GetxController {
  var states = <String>[].obs;
  var cities = <String>[].obs;

  // progress variables
  var doneFetchingStates = false.obs;
  var doneFetchingCities = false.obs;

  Future<void> getCountryStates(String countryName) async {
    doneFetchingStates.value = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> temp =
        sharedPreferences.getStringList(constants.usStatesSPkey) ?? [];
    if (temp.isNotEmpty) {
      print("got states from SP");
      states.addAll(temp);
    } else {
      Stream<String> stream = await location_repo.getCountryStates(countryName);
      stream.listen((String state) {
        // print(state);
        states.add(state);
      }, onError: (e) {
        print("Location Controller Error: $e");
      }, onDone: () {
        doneFetchingStates.value = true;
        try {
          sharedPreferences.remove(constants.usStatesSPkey);
          sharedPreferences.setStringList(constants.usStatesSPkey, states);
        } catch (e) {
          print("Location Controller Error: $e");
        }
      });
    }
  }

  Future<void> getStateCities(String countryName, String stateName) async {
    doneFetchingCities.value = false;
    Stream<String> stream =
        await location_repo.getCountryStateCities(countryName, stateName);
    stream.listen((String state) {
      // print(state);
      cities.add(state);
    }, onError: (e) {
      print("Location Controller Error: $e");
    }, onDone: () {
      doneFetchingCities.value = true;
    });
  }
}
