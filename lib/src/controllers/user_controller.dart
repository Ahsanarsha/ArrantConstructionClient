import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/user.dart';
import 'package:arrant_construction_client/src/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../repositories/user_repo.dart' as user_repo;
import '../helpers/app_constants.dart' as constants;

class UserController extends GetxController {
  User user = User();

  // error string
  final String errorString = "User Controller Error: ";

  void registerUser(BuildContext context) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);

    user_repo.registerUser(user).then((User _user) {
      if (_user.id.isNotEmpty) {
        Fluttertoast.showToast(
            msg: constants.userRegisteredSuccessfully,
            toastLength: Toast.LENGTH_SHORT);
        Get.offAll(const LoginPage());
      } else {
        Helper.getFailedSnackBar();
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
      Helper.getFailedSnackBar();
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void login(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    user_repo.login(user).then((User _user) {
      if (_user.authToken.isNotEmpty) {
        print(_user.authToken);
        Get.offAllNamed('/BottomNavPage/0');
      } else {
        Helper.getFailedSnackBar();
      }
    }).onError((error, stackTrace) {
      print("$errorString $error");
      Helper.getFailedSnackBar();
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  Future<void> updateCurrentUser(BuildContext context, User _user) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    await user_repo.updateUser(_user).then((User _updatedUser) {
      // if user updated successfully
      // update current user object
      if (_updatedUser.id.isNotEmpty) {
        user_repo.currentUser = _updatedUser;
        Fluttertoast.showToast(msg: "User updated");
      }
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(backgroundColor: Colors.red, msg: "Failed!");
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  Future<void> logoutUser() async {
    user_repo.removeCurrentUser().then(
      (value) {
        if (value) {
          Get.offAll(
            const LoginPage(),
            // transition: Transition.rightToLeft,
          );
        }
      },
    ).onError((error, stackTrace) {
      print("$errorString $error");
    }).whenComplete(() {});
  }

  // Future<void> getCurrentUser() async {
  //   user_repo.getCurrentUser().then(
  //     (user) {
  //       Fluttertoast.showToast(msg: "User get successfully");
  //     },
  //   ).onError((error, stackTrace) {
  //     Fluttertoast.showToast(msg: "$errorString $error");
  //   }).whenComplete(() {});
  // }
}
