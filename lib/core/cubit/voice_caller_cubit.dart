import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_configs/agora.config.dart' as config;
import '../../src/utils/commen_extensions.dart';
import '../constants/constants_data.dart';

part 'voice_caller_state.dart';

class VoiceCallerCubit extends Cubit<VoiceCallerState> {
  late final RtcEngine _engine;
  String channelId = config.channelId;
  bool isJoined = false;
  bool openMicrophone = true;
  bool enableSpeakerphone = true;
  bool playEffect = false;
  bool enableInEarMonitoring = false;
  double recordingVolume = 0;
  double playbackVolume = 0;
  double inEarMonitoringVolume = 0;
  bool isRemoteJoined = false;
  bool isMicMute = false;
  bool isSpeakerOpen = false;
  Stopwatch watch = Stopwatch();
  Timer? timer;
  String elapsedTime = '';
  bool isTimerRunning = false;

  late AudioPlayer player;
  VoiceCallerCubit() : super(VoiceCallerInitial()) {
    _initEngine();
    player = AudioPlayer();
  }

  _initEngine() async {
    RtcEngineConfig _config = RtcEngineConfig(config.appId);
    _engine = await RtcEngine.createWithConfig(_config);
    _addListeners();
    await _engine.enableAudio();
  }

  _addListeners() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          log('joinChannelSuccess $channel $uid $elapsed');
          playSound(ConstantData.callerSound);
          emit(
            JoinChannelSuccess(
              channel: channel,
              uid: uid,
              elapsed: elapsed,
            ),
          );
        },
        userJoined: (uid, elapsed) async {
          log('userJoined $uid');
          if (player.playing) {
            await player.stop();
          }
          isRemoteJoined = true;
          _setTimer();
          emit(RemoteUserJoined(uid: uid, elapsed: elapsed));
        },
        leaveChannel: (stats) {
          watch.stop();
          log('leaveChannel ${stats.toJson()}');
          playSound(ConstantData.callDisconnected);
          isRemoteJoined = false;
          emit(LeaveChannel(stats: stats));
        },
        userOffline: (uid, userOfflineReason) {
          watch.stop();
          playSound(ConstantData.connectionLost);
          log('userOffline $userOfflineReason \n $uid');
        },
        activeSpeaker: (value) {
          log('activeSpeaker $value');
        },
        connectionBanned: () async {
          watch.stop();

          log('connectionBanned by agora server');
        },
        connectionInterrupted: () {
          watch.stop();
          playSound(ConstantData.connectionLost);
          log('connectionInterrupted');
        },
        connectionLost: () async {
          watch.stop();
          log('connectionLost');
          playSound(ConstantData.connectionLost);
        },
        microphoneEnabled: (value) {
          log('microphoneEnabled $value');
        },
        userMuteAudio: (uid, status) {
          log('userMuteAudio $uid, \n Status $state');
          emit(UserMuteAudio(isMute: status));
        },
        error: (errorCode) async {
          log('error $errorCode');
          playSound(ConstantData.connectionLost);
        },
        rejoinChannelSuccess: (channel, uid, elapsed) async {
          watch.start();
          log('joinChannelSuccess $channel $uid $elapsed');
          await player.stop();
          emit(JoinChannelSuccess(
            channel: channel,
            uid: uid,
            elapsed: elapsed,
          ));
        },
      ),
    );
  }

  Future<void> playSound(String fileName) async {
    if (player.playing) {
      await player.stop();
    }
    await player.setAsset(fileName);
    player.play();
  }

  Future<void> joinChannel() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Permission.microphone.request();
      }
      //!token, channelName optionalInfo optionalUid,
      await _engine
          .joinChannel(config.token, 'test', null, 0)
          .catchError((onError) {
        print('error ${onError.toString()}');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveChannel() async {
    try {
      await _engine.leaveChannel();
      await _engine.destroy();
    } catch (e) {
      log('Error $e');
    }
  }

  void switchMicrophone() {
    isMicMute = !isMicMute;
    _engine.enableLocalAudio(!isMicMute).then((value) {}).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  void switchSpeakerphone() {
    isSpeakerOpen = !isSpeakerOpen;
    try {
      _engine.setEnableSpeakerphone(isSpeakerOpen).then((value) {
        _engine.setInEarMonitoringVolume(400);
      }).catchError((err) {
        log('setEnableSpeakerphone $err');
      });
    } catch (e) {
      log('Error $e');
    }
  }

  Future<void> updateTime(Timer? timer) async {
    if (watch.isRunning) {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      log('elapsedTime $elapsedTime');
    }
  }

  void _setTimer() {
    watch.start();
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    updateTime(timer);
  }
}
