import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:flutter/material.dart';
import 'package:size_helper/size_helper.dart';

///Don't use it with items or cards (inside any lists) because it uses SizeHelper inside it so the O(n) and the best solution here is to use SizeHelper from the outside and pass the result to every item/card by parameters so the big O will be O(1).
class TitleText extends StatelessWidget {
  const TitleText(
      {super.key,
      required this.text,
      this.subtractedSize = 0.0,
      this.color,
      this.margin,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.fontFamily,
      this.maxLines = 10,
      this.fontWeight = FontWeight.bold,
      this.alignment,
      this.backgroundColor,
      this.padding,
      this.height,
      this.decoration,
      this.decorationColor});

  final String text;
  final double subtractedSize;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final String? fontFamily;
  final int? maxLines;
  final FontWeight? fontWeight;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? height;
  const TitleText.verySmall({
    Key? key,
    required String text,
    Color? color,
    EdgeInsetsGeometry? margin,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    String? fontFamily,
    int? maxLines = 10,
    FontWeight? fontWeight,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          subtractedSize: 9.0,
          color: color,
          margin: margin,
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          maxLines: maxLines,
          fontWeight: fontWeight,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const TitleText.small({
    Key? key,
    required String text,
    Color? color,
    EdgeInsetsGeometry? margin,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    String? fontFamily,
    int? maxLines = 10,
    FontWeight? fontWeight,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          subtractedSize: 6.0,
          color: color,
          margin: margin,
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          maxLines: maxLines,
          fontWeight: fontWeight,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const TitleText.medium({
    Key? key,
    required String text,
    Color? color,
    EdgeInsetsGeometry? margin,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    String? fontFamily,
    int? maxLines = 10,
    FontWeight? fontWeight,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          subtractedSize: 4.0,
          color: color,
          margin: margin,
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          maxLines: maxLines,
          fontWeight: fontWeight,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const TitleText.large({
    Key? key,
    required String text,
    Color? color,
    EdgeInsetsGeometry? margin,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    String? fontFamily,
    int? maxLines = 10,
    FontWeight? fontWeight,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          subtractedSize: -6.0,
          color: color,
          margin: margin,
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          maxLines: maxLines,
          fontWeight: fontWeight,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const TitleText.extraLarge(
      {Key? key,
      required String text,
      Color? color,
      EdgeInsetsGeometry? margin,
      TextAlign textAlign = TextAlign.start,
      TextDirection? textDirection,
      String? fontFamily,
      FontWeight? fontWeight,
      int? maxLines = 10,
      AlignmentGeometry? alignment,
      Color? backgroundColor,
      EdgeInsetsGeometry? padding,
      double? height,
      double subtractedSize = -22})
      : this(
          key: key,
          text: text,
          subtractedSize: subtractedSize,
          color: color,
          margin: margin,
          textAlign: textAlign,
          textDirection: textDirection,
          fontFamily: fontFamily,
          maxLines: maxLines,
          fontWeight: fontWeight,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  @override
  Widget build(BuildContext context) {
    final textStyleBefore = context
        .sizeHelper(
          mobileExtraLarge: Theme.of(context).textTheme.headlineSmall,
          tabletSmall: Theme.of(context).textTheme.headlineMedium,
          tabletLarge: Theme.of(context).textTheme.headlineMedium,
          tabletExtraLarge: Theme.of(context).textTheme.headlineLarge,
          desktopSmall: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 24, height: height),
        )
        .copyWith(
          color: color,
          fontFamily: fontFamily,
          height: height,
        );

    final textStyleAfter = textStyleBefore.copyWith(
        decoration: decoration,
        decorationColor: decorationColor,
        fontSize: ((textStyleBefore.fontSize! - subtractedSize)).h,
        fontWeight: fontWeight);

    Widget child = Text(
      text.tr(),
      softWrap: true,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      textDirection: textDirection,
      style: textStyleAfter,
    );

    if (padding != null) child = Padding(padding: padding!, child: child);

    if (backgroundColor != null)
      child = DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: child,
      );

    if (margin != null) child = Padding(padding: margin!, child: child);

    if (alignment != null) child = Align(alignment: alignment!, child: child);

    return child;
  }
}
