import 'package:flutter/material.dart';

class SimpleElevatedButtonWithIcon extends StatelessWidget {
  const SimpleElevatedButtonWithIcon(
      {required this.label,
      this.color,
      this.iconData,
      this.iconColor,
      required this.onPressed,
      this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      Key? key})
      : super(key: key);
  final Widget label;
  final Color? color;
  final Color? iconColor;
  final IconData? iconData;
  final Function onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed as void Function()?,
      icon: Icon(
        iconData,
        color: iconColor,
      ),
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(6.0),
        ),
      ),
    );
  }
}
