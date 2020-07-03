const _REQUIRED_TEXT = "Informe o valor deste campo!";

final REQUIRED = (value) {
  if (value is String) {
    if (value == null || value.isEmpty) {
      return _REQUIRED_TEXT;
    }
  } else if (value == null) {
    return _REQUIRED_TEXT;
  }
  return null;
};
