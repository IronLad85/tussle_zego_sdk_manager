import 'internal/business/pk/pk_define.dart';
import 'zego_sdk_manager.dart';

abstract class ZegoLiveStreamingManagerInterface {
  void init();
  void uninit();
  Future<ZegoRoomLoginResult?> startLive(String roomID, String token);
  Future<void> startCoHost();
  Future<void> endCoHost();

  Future<PKInviteSentResult> startPKBattle(String anotherHostID);
  Future<PKInviteSentResult> startPKBattleWith(List<String> anotherHostIDList);
  Future<PKInviteSentResult> invitePKBattle(String targetUserID);
  Future<PKInviteSentResult> invitePKBattleWith(List<String> targetUserIDList);
  Future<void> cancelPKBattleRequest(String requestID, String targetUserID);
  Future<void> acceptPKStartRequest(String requestID);
  Future<void> rejectPKStartRequest(String requestID);
  void removeUserFromPKBattle(String userID);
  Future<void> endPKBattle();
  Future<void> quitPKBattle();

  Future<ZegoMixerStartResult> mutePKUser(List<String> muteUserList, bool mute);

  void leaveRoom();
  void clearData();
  void stopPKBattle();

  bool iamHost();
  bool isHost(String userID);
  bool isCoHost(String userID);
  bool isAudience(String userID);

  String hostStreamID();
  String coHostStreamID();

  bool isPKUser(String userID);
  bool isPKUserMuted(String userID);
}
