import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';

void main() {
  group('PhoneNumber.normalize', () {
    test('normalizes supported Pakistani phone formats', () {
      expect(PhoneNumber.normalize('0300 1234567'), '+923001234567');
      expect(PhoneNumber.normalize('92-300-1234567'), '+923001234567');
      expect(PhoneNumber.normalize('+92 (300) 1234567'), '+923001234567');
      expect(PhoneNumber.normalize('00923001234567'), '+923001234567');
    });

    test('keeps a valid international E.164 number', () {
      expect(PhoneNumber.normalize('+447911123456'), '+447911123456');
    });

    test('rejects incomplete and malformed values', () {
      expect(PhoneNumber.normalize('0300'), isNull);
      expect(PhoneNumber.normalize('phone'), isNull);
      expect(PhoneNumber.normalize(''), isNull);
    });
  });
}
