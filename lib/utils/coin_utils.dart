import 'package:flutter/material.dart';

class ChangeData {
  final double value;
  final bool isNegative;
  final Color color;
  final String text;

  ChangeData({
    required this.value,
    required this.isNegative,
    required this.color,
    required this.text,
  });
}

ChangeData getChangeData(String? changeString) {
  final changeValue = double.tryParse(changeString ?? '0') ?? 0;
  final isNegative = changeValue < 0;
  final changeColor = isNegative ? Colors.red : Colors.green;
  final changeText = '${changeValue.abs().toStringAsFixed(2)}%';

  return ChangeData(
    value: changeValue,
    isNegative: isNegative,
    color: changeColor,
    text: changeText,
  );
}

Color? parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;

  var value = hex.trim();
  if (value.startsWith('#')) value = value.substring(1);
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return null;

  final parsed = int.tryParse(value, radix: 16);
  return parsed != null ? Color(parsed) : null;
}

String formatMarketCap(String? value) {
  if (value == null || value.isEmpty) return 'N/A';
  final n = double.tryParse(value.replaceAll(',', ''));
  if (n == null) return value;

  const trillion = 1e12;
  const billion = 1e9;
  const million = 1e6;

  if (n >= trillion) return '${(n / trillion).toStringAsFixed(2)} trillion';
  if (n >= billion) return '${(n / billion).toStringAsFixed(2)} billion';
  if (n >= million) return '${(n / million).toStringAsFixed(2)} million';
  return n.toStringAsFixed(2);
}
