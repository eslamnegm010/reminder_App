
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

  // TextStyle get headline30Bold => TextStyle(
  //   fontSize: 30.fSize,
  //   fontWeight: FontWeight.bold,
  //   color: appTheme.blackCustom,
  // );

  // TextStyle get headline24Regular => TextStyle(
  //   fontSize: 24.fSize,
  //   fontWeight: FontWeight.w400,
  //   color: appTheme.blackCustom,
  // );

  // Title Styles
  // Medium text styles for titles and subtitles

  // TextStyle get title20RegularRoboto => TextStyle(
  //   fontSize: 20.fSize,
  //   fontWeight: FontWeight.w400,
  //   fontFamily: 'Roboto',
  // );

  // TextStyle get title18Medium => TextStyle(
  //   fontSize: 18.fSize,
  //   fontWeight: FontWeight.w500,
  //   color: appTheme.whiteCustom,
  // );

  // TextStyle get title18Bold => TextStyle(
  //   fontSize: 18.fSize,
  //   fontWeight: FontWeight.bold,
  //   color: appTheme.blackCustom,
  // );

  
}
