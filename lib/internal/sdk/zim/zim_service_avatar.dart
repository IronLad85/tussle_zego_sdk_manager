part of 'zim_service.dart';

extension ZIMServiceAvatar on ZIMService {
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(String url) async {
    final result = await ZIM.getInstance()!.updateUserAvatarUrl(url);
    String userId = currentZimUserInfo!.userID;
    userAvatarUrlMap[userId] = result.userAvatarUrl;
    ZEGOSDKManager().currentUser!.avatarUrlNotifier.value =
        result.userAvatarUrl;
    return result;
  }

  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDList) async {
    final config = ZIMUserInfoQueryConfig();
    final result = await ZIM.getInstance()!.queryUsersInfo(userIDList, config);
    for (final userFullInfo in result.userList) {
      String userId = userFullInfo.baseInfo.userID;
      userAvatarUrlMap[userId] = userFullInfo.userAvatarUrl;
      userNameMap[userId] = userFullInfo.baseInfo.userName;
      ZEGOSDKManager().getUser(userId)?.avatarUrlNotifier.value =
          userFullInfo.userAvatarUrl;
    }
    return result;
  }

  Future<ZIMUserNameUpdatedResult> updateUserName(String name) async {
    final result = await ZIM.getInstance()!.updateUserName(name);
    String userId = currentZimUserInfo!.userID;
    userNameMap[userId] = result.userName;
    return result;
  }

  String? getUserAvatar(String userID) {
    return userAvatarUrlMap[userID];
  }

  String? getUserName(String userID) {
    return userNameMap[userID];
  }
}
