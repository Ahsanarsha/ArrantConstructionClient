import 'package:arrant_construction_client/src/pages/project_details.dart';

import '../controllers/home_controller.dart';
import '../helpers/helper.dart';
import '../models/arrant_project.dart';
import '../models/arrant_services.dart';
import '../models/project.dart';
import '../pages/arrant_project_details.dart';
import '../pages/arrant_service_details.dart';
import '../pages/cost_estimation.dart';
import '../widgets/arrant_recent_projects.dart';
import '../widgets/arrant_services_carousel.dart';
import '../widgets/listsWidgets/recent_projects_list.dart';
import '../widgets/loadingWidgets/arrant_projects.dart';
import '../widgets/user_circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;
import '../repositories/user_repo.dart' as user_repo;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _con = Get.put(HomeController());
  // double arrantServicesBoxWidth = MediaQuery.of(context).size.width * 0.90;
  final double _arrantServicesBoxHeight = 150.0;
  final double _arrantServicesBoxBorderRadius = 15.0;

  void _onServiceTap(ArrantServices services) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ArrantServiceDetails(services);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _onArrantProjectClick(ArrantProject _arrantProject) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ArrantProjectDetails(_arrantProject);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.slideRightToLeftTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _onUserRecentProjectClick(Project _p) {
    Get.to(
      ProjectDetails(_p),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void initState() {
    super.initState();
    _con.getArrantServices();
    _con.getArrantProjects();
    _con.getVendorServices();
    _con.getUserOnGoingProjects();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                _sliverFirstList(),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return _con.arrantProjects.isEmpty &&
                        !_con.doneFetchingArrantProjects.value
                    ? const ArrantProjectsLoadingWidget()
                    : _con.arrantProjects.isEmpty &&
                            _con.doneFetchingArrantProjects.value
                        ? const ArrantProjectsLoadingWidget()
                        : ArrantRecentProjects(
                            _con.arrantProjects,
                            _onArrantProjectClick,
                          );
              }),
            ),

            // SliverToBoxAdapter(
            //   child: _recentProjects(),
            // ),
            // SliverToBoxAdapter(child: Obx((){return project_con.}),),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _recentProjects(),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Obx(() {
                    return _con.userOnGoingProjects.isEmpty &&
                            _con.doneFetchingOnGoingProjects.value
                        ? _noProjectsToShow()
                        : _con.userOnGoingProjects.isEmpty &&
                                !_con.doneFetchingOnGoingProjects.value
                            ? const ArrantProjectsLoadingWidget()
                            : RecentProjectsListWidget(
                                _con.userOnGoingProjects,
                                _onUserRecentProjectClick,
                              );
                  }),
                ],
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       Container(
            //         height: MediaQuery.of(context).size.height * 0.40,
            //         // color: Colors.amber,
            //         child: Stack(
            //           children: [
            //             Column(
            //               children: [
            //                 _userInfoContainer(),
            //               ],
            //             ),
            //             Positioned(
            //               top: 100,
            //               child: Obx(() {
            //                 return _con.arrantServices.isEmpty &&
            //                         !_con.doneFetchingArrantServices.value
            //                     ? _servicesErrorWidget()
            //                     : _con.arrantServices.isEmpty &&
            //                             _con.doneFetchingArrantServices.value
            //                         ? _servicesErrorWidget()
            //                         : ServicesCarouselWidget(
            //                             _con.arrantServices,
            //                             onServiceTap: _onServiceTap,
            //                           );
            //               }),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 40,
            //       ),
            //       _costEstimationButton(),
            //       const SizedBox(
            //         height: 40,
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: 50,
            //         color: Colors.white,
            //         child: const Center(
            //           child: Text(
            //             "Work To Admire",
            //             style: TextStyle(
            //               fontSize: 20,
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 40,
            //       ),
            //       _recentProjects(),
            //     ],
            //   ),
            // ),
          ],
          // child: Column(
          //   // mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       height: MediaQuery.of(context).size.height * 0.40,
          //       // color: Colors.amber,
          //       child: Stack(
          //         children: [
          //           Column(
          //             children: [
          //               _userInfoContainer(),
          //             ],
          //           ),
          //           Positioned(
          //             top: 100,
          //             child: Obx(() {
          //               return _con.arrantServices.isEmpty &&
          //                       !_con.doneFetchingArrantServices.value
          //                   ? _servicesErrorWidget()
          //                   : _con.arrantServices.isEmpty &&
          //                           _con.doneFetchingArrantServices.value
          //                       ? _servicesErrorWidget()
          //                       : ServicesCarouselWidget(
          //                           _con.arrantServices,
          //                           onServiceTap: _onServiceTap,
          //                         );
          //             }),
          //           ),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 40,
          //     ),
          //     _costEstimationButton(),
          //     const SizedBox(
          //       height: 40,
          //     ),
          //     Container(
          //       width: MediaQuery.of(context).size.width,
          //       height: 50,
          //       color: Colors.white,
          //       child: const Center(
          //         child: Text(
          //           "Work To Admire",
          //           style: TextStyle(
          //             fontSize: 20,
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 40,
          //     ),
          //     _recentProjects(),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _noProjectsToShow() {
    return const Center(
        child: Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Text("No projects to show!"),
    ));
  }

  List<Widget> _sliverFirstList() {
    return <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        // color: Colors.amber,
        child: Stack(
          children: [
            Column(
              children: [
                _userInfoContainer(),
              ],
            ),
            Positioned(
              top: 100,
              child: Obx(() {
                return _con.arrantServices.isEmpty &&
                        !_con.doneFetchingArrantServices.value
                    ? _servicesErrorWidget()
                    : _con.arrantServices.isEmpty &&
                            _con.doneFetchingArrantServices.value
                        ? _servicesErrorWidget()
                        : ServicesCarouselWidget(
                            _con.arrantServices,
                            onServiceTap: _onServiceTap,
                          );
              }),
            ),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.047,
      ),
      Align(
        alignment: Alignment.center,
        child: _costEstimationButton(),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.047,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.057,
        color: Colors.white,
        child: const Center(
          child: Text(
            "Work To Admire",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      ),
    ];
  }

  Widget _userInfoContainer() {
    const Color nameColor = Colors.white;
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
      ),
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(
          user_repo.currentUser.name,
          style: const TextStyle(
            color: nameColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            Get.offAllNamed('/BottomNavPage/2');
          },
          child: UserCircularAvatar(
            imgUrl: user_repo.currentUser.imageUrl,
            width: 45,
            height: 45,
            adjustment: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _servicesErrorWidget() {
    return Container(
      height: _arrantServicesBoxHeight,
      width: MediaQuery.of(context).size.width * 0.90,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(_arrantServicesBoxBorderRadius),
        ),
        image: const DecorationImage(
          image: AssetImage("assets/img/loading.gif"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _costEstimationButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const CostEstimation();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return Helper.slideRightToLeftTransition(child, animation);
            },
            // transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 50.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
      child: const Text(
        constants.costEstimation,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _recentProjects() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.015,
        ),
        const Text(
          "Recent Projects",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Obx(() {
          return _con.userOnGoingProjects.isEmpty
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    Get.offAllNamed('/BottomNavPage/1');
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
        }),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.015,
        )
      ],
    );
  }
}

// Different methods to navigate between screens

// Get.to(const CostEstimation());

//                 Navigator.pushNamed(
//                     context, 'bottomNavPage/home/cost_estimation');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) {
//                     return const CostEstimation();
//                   }),
//                 );
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation, secondaryAnimation) {
//                       return const CostEstimation();
//                     },
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return Helper.slideRightToLeftTransition(child, animation);
//                     },
//                     transitionDuration: const Duration(milliseconds: 500),
//                   ),
//                 );
//                 Navigator.push(
//                   context,
//                   CupertinoPageRoute(builder: (context) {
//                     return const CostEstimation();
//                   }),
//                 );
