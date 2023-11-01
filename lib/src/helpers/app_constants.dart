import 'package:arrant_construction_client/src/helpers/connection_status.dart';
import 'package:flutter/material.dart';

// Strings
const String arrantConstruction = "Arrant Construction";
const String createNewAccount = "Create New Account";
const String login = "Login";
const String forgotPassword = "Forgot Password?";
const String email = "Email";
const String password = "Password";
const String name = "Name";
const String userName = "User Name";
const confirmPassword = "Confirm Password";
const signup = "Sign Up";
const costEstimation = "Cost Estimation";
const String failed = "Failed!";
const String success = "Success";
const String projectName = "Project Name";
const String description = "Description";
const String selectState = "Select State";
const String selectCity = "Select City";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Messages
const String notAValidEmail = "Not a valid email!";
const String invalidNumber = "Invalid number";
const String noInternetConnection = "No internet connection!";
const String passwordDoesNotMatch = "Password does not match!";
const String passwordContainSpecialChar =
    "Password should be more than 7 characters and should contain any special character!";
const String userRegisteredSuccessfully = "User registered successfully!";
const String somethingWentWrong = "Something went wrong";
const String nameShouldBeMinThreeChar = "Enter your Full Name";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Connection Status
ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Colours
const MaterialColor primarySwatchColor = MaterialColor(
  // 0% comes in here, this will be color picked if no shade
  // is selected when defining a Color property which doesn’t require a swatch.
  0xffFF6631,
  <int, Color>{
    50: Color(0xffff7546), //10%
    100: Color(0xffff855a), //20%
    200: Color(0xffff946f), //30%
    300: Color(0xffffa383), //40%
    400: Color(0xffffb398), //50%
    500: Color(0xffffc2ad), //60%
    600: Color(0xffffd1c1), //70%
    700: Color(0xffffe0d6), //80%
    800: Color(0xfffff0ea), //90%
    900: Color(0xffffffff), //100%
  },
);
const Color primaryColor = Color(0xffFF6631);
const Color secondaryColor = Color(0xff003582);
const Color scaffoldBGC = Color(0xfff6f6f6);
// const Color textFormFieldLabelColor = Colors.grey[300]

////////////////////////////////////////////////////////////////////////////////////////////////

// Bottom Navigation Routes
const List<String> initialRoutes = [
  'bottomNavPage/home',
  'bottomNavPage/projects',
  'bottomNavPage/profile',
  'bottomNavPage/notifications',
];

//////////////////////////////////////////////////////////////////////////////////////////////////////

// Super-scripts
const String squareSC = "\u00B2";

//////////////////////////////////////////////////////////////////////////////////////////////////////

// Base URLs
const String baseUrl = "http://arrantconstruction.mindwhizdev.co/";
const String apiBaseUrl = "http://arrantconstruction.mindwhizdev.co/api/";
const String storageBaseUrl =
    "http://arrantconstruction.mindwhizdev.co/storage/app/public/";

/////////////////////////////////////////////////////////////////////////////////////////////////////////

// USA states and cities
const String countryUSA = "United States";
const String usStatesSPkey = "US States";
const String getCountryStateUrl =
    "https://countriesnow.space/api/v0.1/countries/states";
const String getStateCitiesUrl =
    "https://countriesnow.space/api/v0.1/countries/state/cities";

/////////////////////////////////////////////////////////////////////////////////////////////////////////

// Controller tags
const String projectsConTag = "project_controller_tag";
const String commentsConTag = "comments_controller_tag";
