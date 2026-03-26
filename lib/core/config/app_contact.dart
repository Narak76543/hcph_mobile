class AppContact {
  AppContact._();

  /// Replace with your actual Telegram admin username (without @).
  static const String telegramAdminUsername = 'narak_sarat';

  static Uri get telegramAdminUri =>
      Uri.parse('https://t.me/$telegramAdminUsername');
}
