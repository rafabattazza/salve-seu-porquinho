const _REQUIRED_TEXT = "Informe o valor deste campo!";

final REQUIRED = (value) {
  if (value.isEmpty) {
    return _REQUIRED_TEXT;
  }
  return null;
};
