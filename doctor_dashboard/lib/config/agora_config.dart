// Configuration for Agora video calling
class AgoraConfig {
  // Get your App ID from Agora Console: https://console.agora.io/
  static const String appId = '98d3fa37dec44dc1950b071e3482cfae';

  // For production, generate tokens server-side
  // For development, you can use temporary tokens from Agora Console
  static const String? tempToken = null; // Use null for testing without token

  // Channel settings
  static const int defaultUid = 0; // 0 means auto-assign UID
  static const String channelProfile = 'communication';

  // Video settings
  static const int videoWidth = 640;
  static const int videoHeight = 480;
  static const int videoFrameRate = 15;
  static const int videoBitrate = 400;

  // Audio settings
  static const bool enableAudio = true;
  static const bool enableVideo = true;
}
