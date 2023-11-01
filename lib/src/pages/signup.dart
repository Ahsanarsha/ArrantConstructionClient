import 'package:arrant_construction_client/src/controllers/user_controller.dart';
import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helpers/app_constants.dart' as constants;

class SingupPage extends StatefulWidget {
  const SingupPage({Key? key}) : super(key: key);

  @override
  _SingupPageState createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  final UserController _con = Get.put(UserController());
  late GlobalKey<FormState> _signupFormKey;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _isPasswordVisible = false.obs;

  @override
  void initState() {
    super.initState();
    _signupFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget spaceBetweenFields = SizedBox(
      height: size.height * 0.025,
    );
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _signupFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (input) => _con.user.name = input ?? '',
                    validator: (input) {
                      if (input != null) {
                        return input.length > 5 && input.contains(' ')
                            ? null
                            : "Enter your full name!";
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _signupFormInputDecoration(
                      labelText: constants.name,
                      hintText: "Full name",
                      icon: Icons.person_outline,
                    ),
                  ),
                  spaceBetweenFields,
                  // TextFormField(
                  //   keyboardType: TextInputType.text,
                  //   decoration: _signupFormInputDecoration(
                  //     labelText: constants.userName,
                  //     hintText: "user name",
                  //     icon: Icons.person_outline,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (input) => _con.user.email = input ?? '',
                    validator: (input) => GetUtils.isEmail(input ?? '')
                        ? null
                        : constants.notAValidEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _signupFormInputDecoration(
                      labelText: constants.email,
                      hintText: "user@example.com",
                      icon: Icons.mail_outline,
                    ),
                  ),
                  spaceBetweenFields,
                  Obx(() {
                    return TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _con.user.password = input ?? '',
                      validator: (input) {
                        if (input != null) {
                          if (input.length > 7 &&
                              input.contains(Helper.specialCharacterRegex()) &&
                              input.contains(Helper.alphanumericRegex())) {
                            return null;
                          } else {
                            return constants.passwordContainSpecialChar;
                          }
                        }
                      },
                      obscureText: _isPasswordVisible.value ? false : true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _signupFormInputDecoration(
                        labelText: constants.password,
                        hintText: "********",
                        icon: Icons.lock_outline,
                        suffixIcon: _isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixIconPressed: _changePasswordVisibility,
                      ),
                    );
                  }),
                  spaceBetweenFields,
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if (input == _passwordController.text) {
                        return null;
                      } else {
                        return constants.passwordDoesNotMatch;
                      }
                    },
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _signupFormInputDecoration(
                      labelText: constants.confirmPassword,
                      hintText: "********",
                      icon: Icons.lock_outline,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  _signupButton(),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return TextButton(
      onPressed: () {
        if (constants.connectionStatus.hasConnection) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (!_signupFormKey.currentState!.validate()) {
            return;
          } else {
            _signupFormKey.currentState!.save();
            _con.registerUser(context);
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
        constants.signup,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  InputDecoration _signupFormInputDecoration({
    @required String? labelText,
    @required String? hintText,
    @required IconData? icon,
    IconData? suffixIcon,
    // Function() is function without any params
    Function()? onSuffixIconPressed,
  }) {
    return InputDecoration(
      label: Text(
        labelText ?? "",
      ),
      hintText: hintText,
      labelStyle: TextStyle(
        color: Colors.grey[400],
      ),
      hintStyle: TextStyle(
        color: Colors.grey[400],
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.zero,
      errorMaxLines: 2,
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        onPressed: onSuffixIconPressed ?? () {},
        icon: Icon(suffixIcon),
      ),
      // border: const OutlineInputBorder(
      //   borderSide: BorderSide(
      //     width: 2.0,
      //     color: Colors.grey,
      //   ),
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(5.0),
      //   ),
      // ),
    );
  }

  void _changePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        Get.to(const LoginPage(), transition: Transition.leftToRight);
      },
      child: const Text(
        constants.login,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
