import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget {
  final List<Widget> children;
  const CenterWidget({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}