import 'package:arrant_construction_client/src/models/project_service.dart';
import 'package:arrant_construction_client/src/models/vendor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectRequestAddServiceWidget extends StatefulWidget {
  final List<VendorService> vendorServices;
  final Function onServiceAdd;

  const ProjectRequestAddServiceWidget(this.vendorServices, this.onServiceAdd,
      {Key? key})
      : super(key: key);

  @override
  State<ProjectRequestAddServiceWidget> createState() =>
      _ProjectRequestAddServiceWidgetState();
}

class _ProjectRequestAddServiceWidgetState
    extends State<ProjectRequestAddServiceWidget> {
  ProjectService projectService = ProjectService();

  final TextEditingController _areaTextFieldController =
      TextEditingController();

  final TextEditingController _descriptionTextFieldController =
      TextEditingController();

  String? _selectedServiceId;

  String? _selectedServiceName;

  @override
  Widget build(BuildContext context) {
    FlexFit flexFit = FlexFit.loose;
    Widget sizedBox = const SizedBox(
      width: 10.0,
    );
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              fit: flexFit,
              child: _selectServiceDropDown(context),
            ),
            sizedBox,
            Flexible(
              fit: flexFit,
              child: TextFormField(
                controller: _areaTextFieldController,
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  projectService.areaInSqM = double.parse(value);
                },
                decoration: _projectDetailsFormInputDecoration(
                  labelText: "Area per Sq meter",
                  hintText: "50.5",
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        TextFormField(
          controller: _descriptionTextFieldController,
          maxLength: 70,
          onChanged: (String value) {
            // print(_descriptionTextFieldController.text);
            projectService.description = value;
          },
          decoration: _projectDetailsFormInputDecoration(
            labelText: "Description",
          ),
        ),
        _addServiceButton(context),
      ],
    );
  }

  Widget _addServiceButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // print(projectService.areaInSqM);
        // print(projectService.serviceId);
        if (projectService.areaInSqM != null &&
            projectService.serviceId != null &&
            projectService.description != null) {
          // print("assigning object");
          // print(projectService.serviceId);
          // print(projectService.name);

          widget.onServiceAdd(projectService);
          _areaTextFieldController.text = '';
          _descriptionTextFieldController.text = '';
          // refresh object
          projectService = ProjectService();
        }
        // if service has not changed
        // then the variable is not updated
        // use state variables then and initialize id and name with them
        else if ((projectService.serviceId == null &&
                projectService.name == null) &&
            _selectedServiceId != null &&
            projectService.areaInSqM != null &&
            projectService.description != null) {
          projectService.serviceId = _selectedServiceId;
          projectService.name = _selectedServiceName;
          // print(projectService.serviceId);
          // print(projectService.name);
          widget.onServiceAdd(projectService);
          // remove old values from fields after adding service
          _areaTextFieldController.text = '';
          _descriptionTextFieldController.text = '';
          // refresh object
          projectService = ProjectService();
        }
        // wait
        else {
          Fluttertoast.showToast(msg: "All fields are mandatory!");
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
        "Add",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _selectServiceDropDown(BuildContext context) {
    return DropdownButtonFormField(
      // onSaved: (input) => _con.user.gender = _gender,
      // validator: (input) => _gender.length == 0 ? "Select one" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (VendorService? _vendorService) {
        // print("setting service id and name");
        // print(_vendorService?.id);
        // print(_vendorService?.name);
        projectService.serviceId = _vendorService?.id ?? '';
        _selectedServiceId = _vendorService?.id ?? '';
        projectService.name = _vendorService?.name ?? '';
        _selectedServiceName = _vendorService?.name ?? '';
        // print(_selectedServiceId);
        // print(_selectedServiceName);
      },
      items: widget.vendorServices.map((VendorService _vendorService) {
        return DropdownMenuItem(
          value: _vendorService,
          child: Text(
            _vendorService.name ?? '',
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      iconSize: 20.0,
      decoration: _projectDetailsFormInputDecoration(
        labelText: "Select Service",
      ),
    );
  }

  InputDecoration _projectDetailsFormInputDecoration({
    @required String? labelText,
    String hintText = '',
    double labelFontSize = 12.0,
  }) {
    return InputDecoration(
      label: Text(labelText ?? ""),
      hintText: hintText,
      labelStyle: TextStyle(
        fontSize: labelFontSize,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: labelFontSize,
      ),
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
