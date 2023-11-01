import 'dart:io';
import 'package:arrant_construction_client/src/controllers/user_controller.dart';
import 'package:arrant_construction_client/src/models/user.dart';
import 'package:arrant_construction_client/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:arrant_construction_client/src/widgets/dialogs/edit_profile_dialog.dart';
import 'package:arrant_construction_client/src/widgets/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../repositories/user_repo.dart' as user_repo;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserController _con = Get.put(UserController());

  void updateUser(User _u) {
    _con.updateCurrentUser(context, _u);
  }

  void updateUserImage(File _imageFile) {
    user_repo.currentUser.imageFile = _imageFile;
    _con.updateCurrentUser(context, user_repo.currentUser);
  }

  void logoutUser() {
    _con.logoutUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(user_repo.currentUser.name),
        centerTitle: true,
        actions: [
          _logoutButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            EditProfileDialog(
              user_repo.currentUser,
              updateUser,
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.edit_outlined,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            // updateUser(user_repo.currentUser);
            print("setting state");
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.063,
                ),
                UserData(
                  user: user_repo.currentUser,
                  updateImage: updateUserImage,
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: _userAttributes(),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            "Are you sure you want to logout?",
            logoutUser,
          ),
        );
      },
      icon: const Icon(Icons.logout),
    );
  }

  Text _userProfileTextWidget(
    String text, {
    double size = 15,
    double wordSpacing = 1,
    double height = 1,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: size,
        wordSpacing: wordSpacing,
        height: height,
      ),
    );
  }

  Widget _userAttributeListTile({
    required IconData icon,
    required String text,
  }) {
    return ListTile(
      tileColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: _userProfileTextWidget(
        text == "" ? "Not Added Yet" : text,
        color: Colors.white,
      ),
    );
  }

  Widget _userAttributes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _userProfileTextWidget(
          "Name",
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        _userAttributeListTile(
          icon: Icons.person,
          text: user_repo.currentUser.name,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.037,
        ),
        _userProfileTextWidget(
          "Email",
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        _userAttributeListTile(
          icon: Icons.email,
          text: user_repo.currentUser.email,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.037,
        ),
        _userProfileTextWidget(
          "Phone",
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        _userAttributeListTile(
          icon: Icons.phone,
          text: user_repo.currentUser.contactNumber,
        )
      ],
    );
  }
}
