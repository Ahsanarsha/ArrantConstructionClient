import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/arrant_services.dart';
import 'package:arrant_construction_client/src/pages/cost_estimation.dart';
import 'package:arrant_construction_client/src/widgets/sliver_app_bar.dart';
//import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

//import 'package:get/get.dart';

class ArrantServiceDetails extends StatefulWidget {
  final ArrantServices service;
  const ArrantServiceDetails(this.service, {Key? key}) : super(key: key);

  @override
  State<ArrantServiceDetails> createState() => _ArrantServiceDetailsState();
}

class _ArrantServiceDetailsState extends State<ArrantServiceDetails> {
  // @override
  // void initState() {
  //   BackButtonInterceptor.add(myInterceptor);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   // Get.showSnackbar(
  //   //   const GetSnackBar(
  //   //     message: 'Pressed Back button',
  //   //     duration: Duration(seconds: 2),
  //   //   ),
  //   // );
  //   Navigator.pop(context);

  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // _appBar(context),
          SliverAppBarWidget(widget.service.imageUrl),
          SliverToBoxAdapter(
            child: Container(
              // color: Theme.of(context).scaffoldBackgroundColor,
              // height: 500,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 30,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30),
                //   topRight: Radius.circular(30),
                // ),
              ),
              child: _serviceDetailsContainer(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _namePriceRow(BuildContext context) {
    const double textSize = 15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            widget.service.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textSize,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 1,
          child: Helper.of(context).getPriceRichText(
            widget.service.averagePrice,
            size: textSize,
          ),
        ),
      ],
    );
  }

  Widget _serviceDetailsContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const SizedBox(
        //   height: 20,
        // ),
        _namePriceRow(context),
        const SizedBox(
          height: 50,
        ),
        Text(widget.service.description),
        const SizedBox(
          height: 50,
        ),
        _getQuoteButton(context),
        // const SizedBox(
        //   height: 123,
        // ),
      ],
    );
  }

  Widget _getQuoteButton(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 30.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
      ),
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
      child: const Text(
        "Get Quote",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
