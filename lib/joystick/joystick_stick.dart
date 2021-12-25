import 'package:flutter/material.dart';

class JoystickStick extends StatelessWidget {
  const JoystickStick({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54
      ),
    );
  }
}
