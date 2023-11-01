import 'package:flutter/material.dart';

class ArrantProjectsLoadingWidget extends StatelessWidget {
  final int cardCount;
  const ArrantProjectsLoadingWidget({Key? key, this.cardCount = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cardCount,
          itemBuilder: (context, index) {
            return _loadingCard();
          }),
    );
  }

  Widget _loadingCard() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Image(
        image: AssetImage("assets/img/loading.gif"),
        height: 150,
        width: 150,
      ),
    );
  }
}
