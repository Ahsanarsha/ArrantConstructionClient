import 'package:flutter/material.dart';

class StateNameTile extends StatelessWidget {
  final String stateName;
  final Function? onTap;
  const StateNameTile(
    this.stateName, {
    Key? key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(stateName),
      onTap: () {
        if (onTap != null) {
          // this symbol asserts
          // that you have checked this variable for null check and tell dart
          // because it can be null so you have to null check it before using it
          onTap!(stateName);
        } else {
          print("no method given");
        }
      },
    );
  }
}
