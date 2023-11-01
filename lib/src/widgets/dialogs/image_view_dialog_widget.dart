// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// file no longer in use

// class ImageViewDialogWidget extends StatelessWidget {
//   final double? height;
//   final double? width;
//   final String imgUrl;
//   final bool blurBackground;
//   const ImageViewDialogWidget(
//     this.imgUrl, {
//     Key? key,
//     this.height,
//     this.width,
//     this.blurBackground = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double backgroundBlurValue = blurBackground ? 1.0 : 0.0;
//     return BackdropFilter(
//       filter: ImageFilter.blur(
//           sigmaX: backgroundBlurValue, sigmaY: backgroundBlurValue),
//       child: Dialog(
//         insetPadding: EdgeInsets.zero,
//         // backgroundColor: Theme.of(context).primaryColor,
//         backgroundColor: Colors.transparent,
//         // shape: RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.all(
//         //     Radius.circular(10),
//         //   ),
//         // ),
//         child: CachedNetworkImage(
//           imageUrl: imgUrl,
//           imageBuilder: (context, imageProvider) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.50,
//               width: MediaQuery.of(context).size.width * 0.80,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             );
//           },
//           placeholder: (context, url) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.50,
//               width: MediaQuery.of(context).size.width * 0.80,
//               decoration: const BoxDecoration(
//                 // borderRadius: BorderRadius.circular(5),
//                 // shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage("assets/img/loading.gif"),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             );
//           },
//           errorWidget: (context, error, d) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.50,
//               width: MediaQuery.of(context).size.width * 0.70,
//               decoration: const BoxDecoration(
//                 // borderRadius: BorderRadius.circular(5),
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage("assets/img/profile_placeholder.png"),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
