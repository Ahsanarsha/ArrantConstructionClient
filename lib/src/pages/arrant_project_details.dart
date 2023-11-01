import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/arrant_project.dart';
import 'package:arrant_construction_client/src/widgets/sliver_app_bar.dart';
import 'package:flutter/material.dart';

class ArrantProjectDetails extends StatelessWidget {
  final ArrantProject arrantProject;
  const ArrantProjectDetails(this.arrantProject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // _appBar(context),
        SliverAppBarWidget(arrantProject.imageUrl),
        SliverToBoxAdapter(
          child: Container(
            //color: Theme.of(context).scaffoldBackgroundColor,
            //  height: MediaQuery.of(context).size.height * 0.6,
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
    );
  }

  // Widget _appBar(BuildContext context) {
  //   return SliverAppBar(
  //     expandedHeight: MediaQuery.of(context).size.height * 0.30,
  //     iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
  //     backgroundColor: Colors.transparent,
  //     flexibleSpace: FlexibleSpaceBar(
  //       collapseMode: CollapseMode.parallax,
  //       titlePadding: EdgeInsets.zero,
  //       background: CachedNetworkImage(
  //         imageUrl: "${constants.storageBaseUrl}${arrantProject.imageUrl}",
  //         fit: BoxFit.fill,
  //         placeholder: (context, url) => _imagePlaceHolder(),
  //         errorWidget: (context, url, error) => _imageErrorWidget(),
  //       ),
  //     ),
  //   );
  // }

  // Widget _imagePlaceHolder() {
  //   return const Image(
  //     image: AssetImage("assets/img/loading.gif"),
  //     fit: BoxFit.cover,
  //   );
  // }

  // Widget _imageErrorWidget() {
  //   return const Icon(Icons.error);
  // }

  Widget _namePriceRow(BuildContext context) {
    const double textSize = 15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            arrantProject.name,
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
            arrantProject.price,
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        Text(
          arrantProject.description,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        // _getQuoteButton(context),
        // const SizedBox(
        //   height: 123,
        // ),
      ],
    );
  }
}
