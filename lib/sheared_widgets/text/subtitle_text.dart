import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:size_helper/size_helper.dart';

///Don't use it with items or cards (inside any lists) because it uses SizeHelper inside it so the O(n) and the best solution here is to use SizeHelper from the outside and pass the result to every item/card by parameters so the big O will be O(1).
class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.isBold = false,
    this.subtractedSize = 0.0,
    this.textDirection,
    this.margin,
    this.color,
    this.fontFamily,
    this.maxLines = 10,
    this.underline = false,
    this.alignment,
    this.backgroundColor,
    this.padding,
    this.height,
  });

  final String text;
  final bool isBold;
  final double subtractedSize;
  final double? height;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final String? fontFamily;
  final int? maxLines;
  final bool underline;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const SubtitleText.small({
    Key? key,
    required String text,
    bool isBold = false,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    EdgeInsetsGeometry? margin,
    Color? color,
    String? fontFamily,
    int? maxLines = 10,
    bool underline = false,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          isBold: isBold,
          subtractedSize: 4.0,
          textAlign: textAlign,
          textDirection: textDirection,
          margin: margin,
          color: color,
          fontFamily: fontFamily,
          maxLines: maxLines,
          underline: underline,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );
  const SubtitleText.medium({
    Key? key,
    required String text,
    bool isBold = false,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    EdgeInsetsGeometry? margin,
    Color? color,
    String? fontFamily,
    int? maxLines = 10,
    bool underline = false,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          isBold: isBold,
          subtractedSize: 2.0,
          textAlign: textAlign,
          textDirection: textDirection,
          margin: margin,
          color: color,
          fontFamily: fontFamily,
          maxLines: maxLines,
          underline: underline,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const SubtitleText.large({
    Key? key,
    required String text,
    bool isBold = false,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    EdgeInsetsGeometry? margin,
    Color? color,
    String? fontFamily,
    int? maxLines = 10,
    bool underline = false,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          isBold: isBold,
          subtractedSize: -6.0,
          textAlign: textAlign,
          textDirection: textDirection,
          margin: margin,
          color: color,
          fontFamily: fontFamily,
          maxLines: maxLines,
          underline: underline,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  const SubtitleText.extraLarge({
    Key? key,
    required String text,
    bool isBold = false,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    EdgeInsetsGeometry? margin,
    Color? color,
    String? fontFamily,
    int? maxLines = 10,
    bool underline = false,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? height,
  }) : this(
          key: key,
          text: text,
          isBold: isBold,
          subtractedSize: -10.0,
          textAlign: textAlign,
          textDirection: textDirection,
          margin: margin,
          color: color,
          fontFamily: fontFamily,
          maxLines: maxLines,
          underline: underline,
          alignment: alignment,
          backgroundColor: backgroundColor,
          padding: padding,
          height: height,
        );

  @override
  Widget build(BuildContext context) {
    final textStyleBefore = context
        .sizeHelper(
          mobileLarge:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.0),
          mobileExtraLarge: Theme.of(context).textTheme.bodySmall,
          tabletNormal: Theme.of(context).textTheme.bodyMedium,
          tabletExtraLarge: Theme.of(context).textTheme.bodyLarge!,
        )
        .copyWith(
            color: color,
            fontFamily: fontFamily,
            height: height,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            decoration: underline ? TextDecoration.underline : null,
            decorationColor: color ?? Theme.of(context).canvasColor);

    final textStyleAfter = textStyleBefore.copyWith(
        fontSize: (textStyleBefore.fontSize! - subtractedSize));
    Widget child = Text(
      text.tr(),
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      textDirection: textDirection,
      style: textStyleAfter,
    );

    if (padding != null) child = Padding(padding: padding!, child: child);

    if (backgroundColor != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: child,
      );
    }

    if (margin != null) child = Padding(padding: margin!, child: child);

    if (alignment != null) child = Align(alignment: alignment!, child: child);

    return child;
  }
}
