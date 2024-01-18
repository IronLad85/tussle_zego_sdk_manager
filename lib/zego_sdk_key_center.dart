class SDKKeyCenter {
  static int appID = 0;
  static String appSign = '';

  static void initialize(
    int appIdValue,
    String appSignValue,
    String tokenApiUrl,
  ) {
    appID = appIdValue;
    appSign = appSignValue;
  }
}
