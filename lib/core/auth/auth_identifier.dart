bool looksLikePhoneNumber(String value) {
  final compact = value.replaceAll(RegExp(r'[\s\-()]'), '');
  return RegExp(r'^\+?\d{7,15}$').hasMatch(compact);
}
