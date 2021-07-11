import 'package:flutter/material.dart';

class CallerButtonBuilder extends StatelessWidget {
  final VoidCallback firstOnPressed;
  final String firstTitle;
  final Icon firstIcon;

  final VoidCallback secondOnPressed;
  final String secondTitle;
  final Icon secondIcon;

  final VoidCallback thirdOnPressed;
  final String thirdTitle;
  final Icon thirdIcon;

  const CallerButtonBuilder({
    Key? key,
    required this.firstOnPressed,
    required this.firstTitle,
    required this.firstIcon,
    required this.secondOnPressed,
    required this.secondTitle,
    required this.secondIcon,
    required this.thirdOnPressed,
    required this.thirdTitle,
    required this.thirdIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buttonBuilder(
          icon: firstIcon,
          onPressed: firstOnPressed,
          textTheme: textTheme,
          title: firstTitle,
        ),
        _buttonBuilder(
          icon: secondIcon,
          onPressed: secondOnPressed,
          textTheme: textTheme,
          title: secondTitle,
        ),
        _buttonBuilder(
          icon: thirdIcon,
          onPressed: thirdOnPressed,
          textTheme: textTheme,
          title: thirdTitle,
        ),
      ],
    );
  }

  Widget _buttonBuilder({
    required TextTheme textTheme,
    required VoidCallback onPressed,
    required Icon icon,
    required String title,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
        Text(
          title,
          style: textTheme.subtitle2!.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
