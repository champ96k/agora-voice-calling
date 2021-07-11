import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_configs/screen_names.dart';
import '../../core/core.dart';
import '../widget/primary_button.dart';

class CallerHome extends StatelessWidget {
  const CallerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          onTap: () {
            context.read<VoiceCallerCubit>().joinChannel();
            Navigator.pushNamed(context, ScreenNames.callerScreen);
          },
          text: "Call John",
          width: size.width * 0.8,
        ),
      ),
    );
  }
}
