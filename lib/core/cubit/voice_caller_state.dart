part of 'voice_caller_cubit.dart';

abstract class VoiceCallerState extends Equatable {}

class VoiceCallerInitial extends VoiceCallerState {
  @override
  List<Object?> get props => ['VoiceCallerInitial'];
}

class JoinChannelSuccess extends VoiceCallerState {
  final String channel;
  final int uid;
  final int elapsed;

  JoinChannelSuccess({
    required this.channel,
    required this.uid,
    required this.elapsed,
  });

  List<Object?> get props => [channel, uid, elapsed];
}

class LeaveChannel extends VoiceCallerState {
  final RtcStats stats;
  LeaveChannel({required this.stats});
  List<Object?> get props => [stats];
}

class UserMuteAudio extends VoiceCallerState {
  final bool isMute;
  UserMuteAudio({required this.isMute});
  List<Object?> get props => [isMute];
}

class RemoteUserJoined extends VoiceCallerState {
  final int uid;
  final int elapsed;

  RemoteUserJoined({
    required this.uid,
    required this.elapsed,
  });
  List<Object?> get props => [uid, elapsed];
}
