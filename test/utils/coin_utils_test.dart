import 'package:coinage/utils/coin_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getChangeData', () {
    test('parses a positive change as non-negative with green color', () {
      final data = getChangeData('2.5');

      expect(data.value, 2.5);
      expect(data.isNegative, isFalse);
      expect(data.color, Colors.green);
      expect(data.text, '2.50%');
    });

    test('parses a negative change as negative with red color', () {
      final data = getChangeData('-1.256');

      expect(data.value, -1.256);
      expect(data.isNegative, isTrue);
      expect(data.color, Colors.red);
      expect(data.text, '1.26%');
    });

    test('treats zero as non-negative', () {
      final data = getChangeData('0');

      expect(data.isNegative, isFalse);
      expect(data.color, Colors.green);
      expect(data.text, '0.00%');
    });

    test('defaults to zero when null', () {
      final data = getChangeData(null);

      expect(data.value, 0);
      expect(data.isNegative, isFalse);
      expect(data.text, '0.00%');
    });

    test('defaults to zero when unparsable', () {
      final data = getChangeData('not-a-number');

      expect(data.value, 0);
      expect(data.isNegative, isFalse);
      expect(data.text, '0.00%');
    });
  });

  group('formatMarketCap', () {
    test('returns N/A for null', () {
      expect(formatMarketCap(null), 'N/A');
    });

    test('returns N/A for an empty string', () {
      expect(formatMarketCap(''), 'N/A');
    });

    test('returns the original value when unparsable', () {
      expect(formatMarketCap('not-a-number'), 'not-a-number');
    });

    test('formats trillions', () {
      expect(formatMarketCap('2500000000000'), '2.50 trillion');
    });

    test('formats billions', () {
      expect(formatMarketCap('2500000000'), '2.50 billion');
    });

    test('formats millions', () {
      expect(formatMarketCap('2500000'), '2.50 million');
    });

    test('formats small values with two decimal places', () {
      expect(formatMarketCap('12345.678'), '12345.68');
    });

    test('handles comma-separated values', () {
      expect(formatMarketCap('2,500,000,000'), '2.50 billion');
    });
  });
}
