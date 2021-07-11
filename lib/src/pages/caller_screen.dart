import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/core.dart';

import 'components/callar_button_builder.dart';

class CallerScreen extends StatefulWidget {
  const CallerScreen({Key? key}) : super(key: key);

  @override
  _CallerScreenState createState() => _CallerScreenState();
}

class _CallerScreenState extends State<CallerScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: BlocConsumer<VoiceCallerCubit, VoiceCallerState>(
        listenWhen: (previous, current) {
          if (current is LeaveChannel) {
            return true;
          } else {
            return false;
          }
        },
        listener: (context, state) {
          if (state is LeaveChannel) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final String elapsedTime =
              context.select((VoiceCallerCubit state) => state.elapsedTime);
          return Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0c0c0c),
                  Color(0xff4834d4),
                  Color(0xff00264D),
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "John Deo",
                        style: textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: size.height * 0.014),
                      Text(
                        context.select((VoiceCallerCubit value) =>
                                value.isRemoteJoined)
                            ? elapsedTime
                            : "Calling",
                        style: textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.dialer_sip_sharp,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Keypad",
                                style: textTheme.subtitle2!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      CallerButtonBuilder(
                        firstOnPressed: () {},
                        firstTitle: "Record",
                        firstIcon: const Icon(
                          Icons.voicemail,
                          color: Colors.white,
                        ),
                        secondOnPressed: () {},
                        secondTitle: "On hold",
                        secondIcon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        thirdOnPressed: () {
                          context.read<VoiceCallerCubit>().switchMicrophone();
                        },
                        thirdTitle: "Mute",
                        thirdIcon: Icon(
                          context.select(
                                  (VoiceCallerCubit state) => state.isMicMute)
                              ? Icons.mic
                              : Icons.mic_off,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      CallerButtonBuilder(
                        firstOnPressed: () {},
                        firstTitle: "Add call",
                        firstIcon: const Icon(
                          Icons.add_box,
                          color: Colors.white,
                        ),
                        secondOnPressed: () {},
                        secondTitle: "Contact",
                        secondIcon: const Icon(
                          Icons.perm_contact_cal,
                          color: Colors.white,
                        ),
                        thirdOnPressed: () {
                          context.read<VoiceCallerCubit>().switchSpeakerphone();
                        },
                        thirdTitle: "Speaker",
                        thirdIcon: Icon(
                          context.select((VoiceCallerCubit state) =>
                                  state.isSpeakerOpen)
                              ? Icons.volume_up
                              : Icons.volume_down,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      final _isJoined = context
                          .select((VoiceCallerCubit state) => state.isJoined);
                      if (_isJoined) {
                        context.read<VoiceCallerCubit>().leaveChannel();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.call_end_sharp,
                      color: Colors.red,
                      size: 42.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
