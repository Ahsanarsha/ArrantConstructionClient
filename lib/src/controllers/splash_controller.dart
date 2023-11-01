import 'package:arrant_construction_client/src/models/user.dart';
import 'package:arrant_construction_client/src/pages/login.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import '../repositories/user_repo.dart' as user_repo;

class SplashController extends GetxController {
  // go to next screen
  // after splash screen
  Future<void> goToNextScreen() async {
    user_repo.getCurrentUser().then((User _user) {
      if (_user.authToken.isNotEmpty) {
        Get.offAllNamed('/BottomNavPage/0');
      } else {
        Get.offAll(
          const LoginPage(),
          transition: Transition.rightToLeft,
        );
      }
    }).onError((error, stackTrace) {
      print("Splash Controller Error: $error");
    }).whenComplete(() {});
  }
}
