import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:io';

/// Extension on num to provide additional functionalities
extension NumExt on num {
  /// Convert num to double
  Widget get verticalSpace => SizedBox(
        height: toDouble(),
      );

  /// Convert num to double
  Widget get horizontalSpace => SizedBox(
        width: toDouble(),
      );

  /// Convert num to double
  Widget get sliverVerticalSpace => SizedBox(
        height: toDouble(),
      ).sliverBox;

  /// Convert num to double
  Widget get sliverHorizontalSpace => SizedBox(
        width: toDouble(),
      ).sliverBox;

  /// Convert num to double
  String get compact =>
      NumberFormat.compact(locale: Platform.localeName).format(this);

  /// Comma separated number
  String get commaSeparated =>
      NumberFormat.decimalPattern(Platform.localeName).format(this);

  /// Convert num to double
  double get truncateToDecimal =>
      (this * pow(10, this)).truncate() / pow(10, this);
}
