class EndPoints {
  EndPoints._();
  //Chat gpt
  static const String chatCompletionGPT = '/chat/completions';
  static const String chatCompletion = '/completions';
  static const String models = '/models';

  //App endpoints
  static const String allMessages = '/messages';
  static const String sendMessage = '/messages/store';

  static const String allchats = '/chats';
  static const String createChat = '/chats/create';
  static const String deleteChat = '/chats/delete';

  //ads
  static const String adReward = '/quota/adReward';

  //Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String sendOtp = '/createSession';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/update';
  static const String changePhone = '/auth/changePhone';
  static const String changePassword = '/auth/changePassword';
  static const String logout = '/logout';
}
