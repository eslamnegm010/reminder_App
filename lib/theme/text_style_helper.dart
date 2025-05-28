import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline30Bold => TextStyle(
    fontSize: 30.fSize,
    fontWeight: FontWeight.bold,
    color: appTheme.blackCustom,
  );

  TextStyle get headline24Regular => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.blackCustom,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title20Regular => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.colorFFA1A1,
  );

  TextStyle get title18Medium => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.whiteCustom,
  );

  TextStyle get title18Bold => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.bold,
    color: appTheme.blackCustom,
  );

  TextStyle get title18Regular => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.colorFF9A9A,
  );

  TextStyle get title16SemiBold => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.blackCustom,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14Regular => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.colorFF9999,
  );
}
