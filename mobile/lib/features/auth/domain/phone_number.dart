abstract final class PhoneNumber {
  static String? normalize(String input) {
    var value = input.replaceAll(RegExp(r'[\s()\-]'), '');

    if (value.startsWith('00')) value = '+${value.substring(2)}';
    if (value.startsWith('0')) value = '+92${value.substring(1)}';
    if (value.startsWith('92')) value = '+$value';

    return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(value) ? value : null;
  }
}
