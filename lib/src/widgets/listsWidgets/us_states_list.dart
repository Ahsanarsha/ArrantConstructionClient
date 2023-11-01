import 'package:arrant_construction_client/src/widgets/listTiles/state_name_tile.dart';
import 'package:flutter/material.dart';

class UsStatesList extends StatelessWidget {
  final List<String> states;
  final Function? onTap;
  const UsStatesList(
    this.states, {
    Key? key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50 * states.length.toDouble(),
      child: ListView.separated(
        itemCount: states.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return StateNameTile(
            states[index],
            onTap: onTap,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
