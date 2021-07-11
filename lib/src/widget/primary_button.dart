import 'package:flutter/material.dart';
import '../../core/constants/constant_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color color;
  final Color textColor;
  final FontWeight fontWeight;
  const PrimaryButton({
    Key? key,
    @required this.text,
    @required this.onTap,
    this.color = ConstantColors.primaryorange,
    this.height,
    this.width,
    this.fontWeight = FontWeight.w400,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? size.height * 0.06,
        width: width ?? size.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(0.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text!,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
