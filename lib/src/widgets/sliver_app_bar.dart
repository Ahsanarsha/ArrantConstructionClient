import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../helpers/app_constants.dart' as constants;

class SliverAppBarWidget extends StatelessWidget {
  final String url;
  double? height;
  SliverAppBarWidget(
    this.url, {
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height ?? MediaQuery.of(context).size.height * 0.30,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.zero,
        background: CachedNetworkImage(
          imageUrl: "${constants.storageBaseUrl}$url",
          fit: BoxFit.fill,
          placeholder: (context, url) => _imagePlaceHolder(),
          errorWidget: (context, url, error) => _imageErrorWidget(),
        ),
      ),
    );
  }

  Widget _imagePlaceHolder() {
    return const Image(
      image: AssetImage("assets/img/loading.gif"),
      fit: BoxFit.cover,
    );
  }

  Widget _imageErrorWidget() {
    return const Icon(Icons.error);
  }
}
