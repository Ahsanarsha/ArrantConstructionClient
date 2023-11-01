import '../controllers/project_controller.dart';
import '../helpers/helper.dart';
import '../models/project_media_library.dart';
import '../models/project_service.dart';
import '../pages/show_country_states.dart';
import '../pages/show_state_cities.dart';
import '../widgets/projectRequestWidgets/add_service.dart';
import '../widgets/projectRequestWidgets/added_media_list.dart';
import '../widgets/projectRequestWidgets/added_services_list.dart';
import '../widgets/projectRequestWidgets/project_creating_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;

class CostEstimation extends StatefulWidget {
  const CostEstimation({Key? key}) : super(key: key);

  @override
  _CostEstimationState createState() => _CostEstimationState();
}

class _CostEstimationState extends State<CostEstimation> {
  final String _controllerTag = "Main Project Controller Instance";
  late ProjectController _con;
  late GlobalKey<FormState> _projectFormKey;

  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  void _addService(ProjectService _service) {
    _con.projectRequestAddedServices.add(_service);
  }

  void _onServiceDelete(int index) {
    // delete service from _con.project service added list
    _con.projectRequestAddedServices.removeAt(index);
  }

  void onMediaItemDeleted(int index) {
    _con.projectMediaLibList.removeAt(index);
  }

  @override
  void initState() {
    super.initState();

    _con = Get.put(ProjectController(), tag: _controllerTag);
    _projectFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double sizedBoxHeight = MediaQuery.of(context).size.height * 0.025;

    Widget sizedBox = SizedBox(
      height: sizedBoxHeight,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Project Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Form(
          key: _projectFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox,
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (input) => _con.project.name = input ?? '',
                  validator: (input) => input != null && input.length > 4
                      ? null
                      : "Should be more than 4 characters!",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _projectDetailsFormInputDecoration(
                    labelText: constants.projectName,
                  ),
                ),
                sizedBox,
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    onSaved: (input) => _con.project.description = input ?? '',
                    validator: (input) =>
                        input != null && input.length > 1 ? null : "Mandatory!",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 500,
                    maxLines: null,
                    decoration: _projectDetailsFormInputDecoration(
                      labelText: constants.description,
                    ),
                  ),
                ),
                sizedBox,
                _selectState(),
                sizedBox,
                _selectCity(),
                sizedBox,
                _addServiceTextWidget(),
                sizedBox,
                _showAddedServices(),
                sizedBox,
                // sizedBox,
                ProjectRequestAddServiceWidget(
                  Helper.getVendorServices(),
                  _addService,
                ),
                sizedBox,
                _addImagesTextWidget(),
                sizedBox,
                _showAddedImages(),
                sizedBox,
                _chooseFilesButton(),
                sizedBox,
                Align(
                  alignment: Alignment.center,
                  child: _createProjectButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createProjectButton() {
    return TextButton(
      onPressed: () {
        if (constants.connectionStatus.hasConnection) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (!_projectFormKey.currentState!.validate()) {
            return;
          } else if (_con.projectRequestAddedServices.isEmpty) {
            Fluttertoast.showToast(msg: "Add at least 1 service");
          } else {
            _projectFormKey.currentState!.save();
            _con.project.location =
                "${_cityNameController.text}, ${_stateNameController.text}, USA";
            _con.project.status = 1;
            _con.createProject(context);
            Get.bottomSheet(
              ProjectCreatingBottomSheet(_controllerTag),
            );
          }
        } else {
          // print("no connection");
          Fluttertoast.showToast(msg: constants.noInternetConnection);
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 50.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      child: const Text(
        "Request",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _chooseFilesButton() {
    return TextButton(
      onPressed: () async {
        ProjectMediaLibrary mediaLib = ProjectMediaLibrary();
        XFile? tempFile =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (tempFile != null) {
          mediaLib.imageFile = tempFile;
          mediaLib.name = tempFile.name;
          mediaLib.status = 1;
          mediaLib.mediaType = 1;
          _con.projectMediaLibList.add(mediaLib);
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      child: const Text(
        "Choose Files",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _showAddedImages() {
    return Obx(() {
      return _con.projectMediaLibList.isEmpty
          ? const SizedBox(
              height: 0.0,
              width: 0.0,
            )
          : ProjectRequestAddedMediaList(
              _con.projectMediaLibList,
              onMediaItemDeleted,
            );
    });
  }

  Widget _addServiceTextWidget() {
    return Text(
      "Add Services",
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _addImagesTextWidget() {
    return Text(
      "Add Images",
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _selectState() {
    return TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      controller: _stateNameController,
      keyboardType: TextInputType.text,
      readOnly: true,
      enableInteractiveSelection: false, // disabled paste opr
      // onSaved: (input) => _con.user.videoUrl = input,
      validator: (input) {
        return input == null ? "Mandatory!" : null;
      },
      onTap: () {},
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: constants.selectState,

        // hintText: Constants.youtube_video_link,

        suffixIcon: IconButton(
          onPressed: () async {
            // open bottom sheet
            // fetch all states of United States
            // select one state and send back
            FocusScope.of(context).requestFocus(FocusNode());
            String state = await Get.to(
              const ShowCountryStates(constants.countryUSA),
              fullscreenDialog: true,
              transition: Transition.downToUp,
            );
            // print(state);
            // _state = state;
            _stateNameController.text = state;
          },
          icon: Icon(
            Icons.arrow_drop_down_circle,
            color: Theme.of(context).colorScheme.secondary,
            // size: 30,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _selectCity() {
    return TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      controller: _cityNameController,
      keyboardType: TextInputType.text,
      readOnly: true,
      enableInteractiveSelection: false, // disabled paste opr
      // onSaved: (input) => _con.user.videoUrl = input,
      validator: (input) {
        return input == null ? "Mandatory!" : null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: constants.selectCity,

        // hintText: Constants.youtube_video_link,

        suffixIcon: IconButton(
          onPressed: () async {
            // open bottom sheet
            // fetch all cities of selected state
            // select one city and send back
            FocusScope.of(context).requestFocus(FocusNode());
            if (_stateNameController.text.isNotEmpty) {
              // if state is selected
              String city = await Get.to(
                ShowStateCities(
                    constants.countryUSA, _stateNameController.text),
                fullscreenDialog: true,
                transition: Transition.downToUp,
              );
              // print(city);
              _cityNameController.text = city;
            } else {
              Fluttertoast.showToast(msg: "Select State");
            }
          },
          icon: Icon(
            Icons.arrow_drop_down_circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _showAddedServices() {
    return Obx(() {
      return _con.projectRequestAddedServices.isEmpty
          ? const SizedBox(
              height: 0.0,
              width: 0.0,
            )
          : ProjectRequestAddedServicesList(
              _con.projectRequestAddedServices,
              _onServiceDelete,
            );
    });
  }

  InputDecoration _projectDetailsFormInputDecoration({
    @required String? labelText,
  }) {
    return InputDecoration(
      label: Text(labelText ?? ""),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.all(10),
      errorMaxLines: 2,
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
    );
  }
}

//to disable textfield
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
