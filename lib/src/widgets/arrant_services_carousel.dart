import 'package:arrant_construction_client/src/models/arrant_services.dart';
import 'package:arrant_construction_client/src/widgets/arrant_service_builder.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ServicesCarouselWidget extends StatelessWidget {
  final List<ArrantServices> images;
  final Function? onServiceTap;
  const ServicesCarouselWidget(
    this.images, {
    this.onServiceTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.25,
          // height: 200,
          autoPlay: true,
        ),
        items: images.map((ArrantServices service) {
          return _serviceBuilder(service);
        }).toList(),
      ),
    );
  }

  Widget _serviceBuilder(ArrantServices _service) {
    return GestureDetector(
      onTap: () {
        if (onServiceTap == null) {
          print("No method given");
        } else {
          onServiceTap!(_service);
        }
      },
      child: ArrantServiceBuilder(_service),
    );
  }
}
