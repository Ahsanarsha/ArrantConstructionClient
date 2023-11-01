import 'dart:io';
import 'package:arrant_construction_client/src/models/user.dart';
import 'package:arrant_construction_client/src/widgets/dialogs/general_image_view_dialog.dart';
import 'package:arrant_construction_client/src/widgets/dialogs/image_dialog.dart';
import 'package:arrant_construction_client/src/widgets/user_circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';

class UserData extends StatelessWidget {
  final User user;
  final Function updateImage;
  // image file variables
  late File _imageFile;
  var imageName = "".obs;
  final ImagePicker _picker = ImagePicker();

  UserData({
    Key? key,
    required this.user,
    required this.updateImage,
  }) : super(key: key);

  void _selectImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      imageName.value = _imageFile.path.split('/').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() {
              print(user.imageUrl);
              return imageName.value.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (user.imageUrl.isNotEmpty) {
                          Get.dialog(
                            ImageDialogWidget(
                              user.imageUrl,
                            ),
                          );
                        }
                      },
                      child: UserCircularAvatar(
                        imgUrl: user.imageUrl,
                        height: 120.0,
                        width: 100.0,
                        adjustment: BoxFit.fill,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ImageProvider profileImage = FileImage(_imageFile);
                        Get.dialog(
                          GeneralImageViewDialog(
                            profileImage,
                          ),
                        );
                      },
                      child: Container(
                        height: 120.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(_imageFile),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
            }),
            Positioned(
                top: 75,
                left: 60,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _selectImage();
                      },
                    ),
                  ),
                )),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return TextButton(
                  onPressed: () {
                    if (imageName.value.isNotEmpty) {
                      updateImage(_imageFile);
                      imageName.value = "";
                    }
                  },
                  child: Text(
                    "Update Image",
                    style: TextStyle(
                      color: imageName.value.isNotEmpty
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                    ),
                  ),
                );
              }),
              Obx(() {
                return TextButton(
                  onPressed: () {
                    if (imageName.value.isNotEmpty) {
                      // reset file value
                      imageName.value = "";
                    }
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: imageName.value.isNotEmpty
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.035,
        // ),
      ],
    );
  }
}
