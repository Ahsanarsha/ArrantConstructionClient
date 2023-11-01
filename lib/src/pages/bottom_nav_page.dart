// import 'package:arrant_construction_client/src/pages/cost_estimation.dart';
import 'package:arrant_construction_client/src/pages/home.dart';
import 'package:arrant_construction_client/src/pages/notifications.dart';
import 'package:arrant_construction_client/src/pages/profile.dart';
import 'package:arrant_construction_client/src/pages/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationPage extends StatefulWidget {
  int? index;
  BottomNavigationPage({
    Key? key,
  }) : super(key: key) {
    print(Get.parameters['index']);
    index = int.parse(Get.parameters['index'] ?? "0");
  }

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  var currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: Obx(() {
        return IndexedStack(
          index: currentIndex.value,
          children: [
            Navigator(
              initialRoute: 'bottomNavPage/home',
              // initialRoute: constants.initialRoutes[0],
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'bottomNavPage/home':
                    builder = (BuildContext context) => const Home();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'bottomNavPage/projects',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'bottomNavPage/projects':
                    builder = (BuildContext context) => const Projects();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'bottomNavPage/profile',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'bottomNavPage/profile':
                    builder = (BuildContext context) => const Profile();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
            Navigator(
              initialRoute: 'bottomNavPage/notifications',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                // print(settings.name);
                switch (settings.name) {
                  case 'bottomNavPage/notifications':
                    builder =
                        (BuildContext context) => const NotificationsPage();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(
                    builder: builder, settings: settings);
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomNavigationBar() {
    Radius _bottomNavBarCurveRadius = const Radius.circular(15);
    double iconSize = 20.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          topLeft: _bottomNavBarCurveRadius,
          topRight: _bottomNavBarCurveRadius,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: _bottomNavBarCurveRadius,
          topRight: _bottomNavBarCurveRadius,
        ),
        child: Obx(() {
          // print("bottom nav rebuilt");
          return BottomNavigationBar(
            onTap: _onIconTap,
            currentIndex: currentIndex.value,
            // dont explicitly define colours
            // when type is fixed
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
            ),
            items: [
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.home,
                  size: iconSize,
                ),
                label: "Home",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.tasks,
                  size: iconSize,
                ),
                label: "Projects",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: iconSize,
                ),
                label: "Profile",
              ),
              _bottomNavBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  size: iconSize,
                ),
                label: "Notifications",
              ),
            ],
          );
        }),
      ),
    );
  }

  void _onIconTap(int index) {
    // print(index);
    currentIndex.value = index;
  }

  BottomNavigationBarItem _bottomNavBarItem({
    @required Widget? icon,
    String? label,
  }) {
    return BottomNavigationBarItem(
      icon: icon ??
          const SizedBox(
            height: 0.0,
            width: 0.0,
          ),
      label: label ?? '',
    );
  }
}
