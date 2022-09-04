import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final List<Widget> children;
  final double width;

  const BoxWidget({Key? key, required this.width, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )),
    );
  }
}

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

class SizedBoxWidget extends StatelessWidget {
  final double height;
  final Widget child;

  const SizedBoxWidget({Key? key, required this.height, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: child,
    );
  }
}
