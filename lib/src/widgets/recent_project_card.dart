import 'package:arrant_construction_client/src/helpers/helper.dart';
import 'package:arrant_construction_client/src/models/project.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../helpers/app_constants.dart' as constants;

class RecentProjectCardWidget extends StatelessWidget {
  final Project project;
  final double boxBorderRadius = 15;
  const RecentProjectCardWidget(this.project, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(boxBorderRadius),
        ),
      ),
      child: Column(
        children: [
          project.mediaLibraryFiles.isNotEmpty
              ? _ProjectImage(
                  project.mediaLibraryFiles[0].url,
                  boxBorderRadius,
                )
              : _imageErrorBuilder(110),
          _namePriceWidget(context),
        ],
      ),
    );
  }

  Widget _namePriceWidget(BuildContext context) {
    double textSize = 10.0;
    return ListTile(
      title: Text(
        project.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Helper.of(context).getPriceRichText(
        project.estimatedCost,
        size: textSize,
      ),
    );
  }
}

Widget _imageErrorBuilder(double height) {
  return Container(
    height: height,
    // width: imageWidth,
    decoration: const BoxDecoration(
      // borderRadius: BorderRadius.circular(5),
      shape: BoxShape.circle,
      image: DecorationImage(
        image: AssetImage("assets/img/image_placeholder.png"),
        fit: BoxFit.contain,
      ),
    ),
  );
}

class _ProjectImage extends StatelessWidget {
  final String url;
  final double imageHeight = 110.0;
  final double boxBorderRadius;
  const _ProjectImage(this.url, this.boxBorderRadius, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${constants.storageBaseUrl}$url",
      imageBuilder: (context, imageProvider) {
        return Container(
          height: imageHeight,
          // width: imageWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(boxBorderRadius),
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Container(
          height: imageHeight,
          // width: imageWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(boxBorderRadius),
            ),
            image: const DecorationImage(
              image: AssetImage("assets/img/loading.gif"),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      errorWidget: (context, error, d) {
        // print(error.toString());
        // print(d.toString());
        return _imageErrorBuilder(imageHeight);
      },
    );
  }
}
