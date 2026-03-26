String buildGoogleLinkedPassword(String firebaseUid) {
  final compact = firebaseUid.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
  final seed = compact.isEmpty ? 'googleuser' : compact;
  final token = seed.length > 18 ? seed.substring(0, 18) : seed;
  return 'Gg#$token@26';
}
