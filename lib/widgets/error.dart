import 'package:flutter/material.dart';

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'You are not allowed to view the requested resource!',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
