import "package:agora_rtc_engine/agora_rtc_engine.dart";
import 'package:get/get.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:frontend/secret.dart';

class AgoraApi {
  String channelName = 'new channel';

  late RtcEngine _engine;

  Future<void> initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: Agora_AppID));
  }
}
