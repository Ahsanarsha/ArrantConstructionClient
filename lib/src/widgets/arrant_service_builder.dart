import 'package:arrant_construction_client/src/models/arrant_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../helpers/app_constants.dart' as constants;

class ArrantServiceBuilder extends StatelessWidget {
  final ArrantServices service;
  const ArrantServiceBuilder(this.service, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${constants.storageBaseUrl}${service.imageUrl}",
      imageBuilder: (context, imageProvider) {
        return _imgaeBuilder(context, imageProvider, false);
      },
      errorWidget: (context, url, error) {
        // print("error");
        // print(d);
        ImageProvider image =
            const AssetImage("assets/img/image_placeholder.png");
        return _imgaeBuilder(context, image, true);
      },
    );
  }

  Widget _imgaeBuilder(
      BuildContext context, ImageProvider image, bool isErroneous) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isErroneous ? Colors.white : Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        image: DecorationImage(
          image: image,
          fit: BoxFit.fill,
        ),
      ),
      child: _serviceNameStack(context),
    );
  }

  Widget _serviceNameStack(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          right: 10,
          child: Text(
            service.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
