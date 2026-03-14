import 'dart:async';

import 'package:reminder_app/core/utils/type_defs.dart';
import 'package:reminder_app/res/theme/app_colors.dart';
import 'package:reminder_app/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum _DefaultButtonLabelType { verySmall, small, medium, large, extraLarge }

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.w400,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor = AppColors.blueColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = null;
  const DefaultButton.verySmall({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.bold,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = _DefaultButtonLabelType.verySmall;
  const DefaultButton.small({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.bold,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor = AppColors.blueColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = _DefaultButtonLabelType.small;
  const DefaultButton.medium({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.bold,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = _DefaultButtonLabelType.medium;

  const DefaultButton.large({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.w500,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor = AppColors.blueColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = _DefaultButtonLabelType.large;
  const DefaultButton.extraLarge({
    super.key,
    this.label,
    this.labelWidget,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.labelStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.Dark,
      fontWeight: FontWeight.bold,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(30.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = true,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.iconLocation = DefaultButtonIconLocation.Start,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.gradient = AppColors.COMPOUND_GRADIENT,
    this.initLoadingState = false,
    this.loadingSize,
    this.animationDuration = const Duration(milliseconds: 700),
    this.labelColor,
    this.shape = BoxShape.rectangle,
    this.elevation,
  }) : assert(
         label == null || labelWidget == null,
         'You must provide only a label or a labelWidget but not both.',
       ),
       _labelType = _DefaultButtonLabelType.extraLarge;
  final _DefaultButtonLabelType? _labelType;
  final FutureCallback? onPressed;
  final String? label;
  final Widget? labelWidget;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle labelStyle;
  final Color? borderColor;
  final AlignmentGeometry? alignment;
  final BorderRadiusGeometry borderRadius;
  final bool isExpanded;
  final bool keepButtonSizeOnLoading;
  final Widget? icon;
  final DefaultButtonIconLocation iconLocation;
  final double borderWidth;
  final bool enabled;

  /// This is ignored if [gradient] is non-null.
  final Color? backgroundColor;

  /// If this is specified, [color] has no effect.
  final Gradient? gradient;

  final List<BoxShadow>? shadow;
  final MainAxisAlignment contentAlignment;
  final bool initLoadingState;
  final double? loadingSize;
  final Duration animationDuration;
  final Color? labelColor;
  final BoxShape shape;
  final double? elevation;
  @override
  DefaultButtonState createState() => DefaultButtonState();
}

class DefaultButtonState extends State<DefaultButton> with TickerProviderStateMixin {
  bool _isBusy = false;
  bool _isFirstBuild = true;

  @override
  void initState() {
    _isBusy = widget.initLoadingState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconOnStart = widget.iconLocation == DefaultButtonIconLocation.Start;
    final buttonContents = <Widget>[
      if (widget.icon != null) ...[
        widget.icon!,
        if (widget.label != null) const SizedBox(width: 8.0),
      ],
      if (widget.label != null || widget.labelWidget != null)
        Padding(
          padding: widget.icon != null
              ? const EdgeInsets.only(top: 3.0)
              : EdgeInsets.zero,
          child: widget.labelWidget ?? _buildLabelText(),
        ),
    ];

    Widget child = _AnimatedClipRRect(
      needToAnimate: !_isFirstBuild,
      duration: widget.animationDuration,
      curve: Curves.elasticInOut,
      border: widget.borderColor != null
          ? Border.all(
              color: widget.borderColor!,
              width: widget.borderWidth,
              strokeAlign: BorderSide.strokeAlignOutside,
            )
          : null,
      borderRadius: _isBusy && !widget.keepButtonSizeOnLoading
          ? BorderRadius.circular(100.0)
          : widget.borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.enabled ? widget.backgroundColor : const Color(0x88888888),
          gradient: widget.backgroundColor == null && widget.enabled
              ? widget.gradient
              : null,
          boxShadow: widget.shadow,
          shape: widget.shape,
        ),
        child: AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.elasticInOut,
          child: _isBusy
              ? _buildLoading(widget.keepButtonSizeOnLoading)
              : GestureDetector(
                  onTap: widget.enabled && widget.onPressed != null
                      ? () {
                          FocusScope.of(context).unfocus();
                          final futureOr = widget.onPressed!();
                          if (futureOr is Future) {
                            _setButtonToBusy();
                            futureOr.whenComplete(_setButtonToReady);
                          }
                        }
                      : null,
                  child: AbsorbPointer(
                    child: Padding(
                      padding: widget.padding,
                      child: Row(
                        mainAxisSize: widget.isExpanded
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: widget.contentAlignment,
                        children: iconOnStart
                            ? buttonContents
                            : buttonContents.reversed.toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );

    if (widget.alignment != null) {
      child = Align(alignment: widget.alignment!, child: child);
    }

    if (widget.margin != null) child = Padding(padding: widget.margin!, child: child);

    if (widget.elevation != null) {
      child = PhysicalModel(
        elevation: widget.elevation!,
        color: Colors.transparent,
        shadowColor: Colors.black,
        shape: widget.shape,
        borderRadius: widget.borderRadius as BorderRadius?,
        child: child,
      );
    }
    return child;
  }

  Widget _buildLoading(bool keepButtonSizeOnLoading) {
    final loadingSizeFromTextSize = (widget.labelStyle.fontSize ?? 16.0) * 2.0;
    final loadingSize = widget.loadingSize ?? loadingSizeFromTextSize;
    final padding = widget.padding.vertical / 2;
    return Container(
      padding: EdgeInsets.all(padding),
      width: keepButtonSizeOnLoading ? null : (loadingSize + padding * 2),
      height: (loadingSize + padding * 2),
      alignment: keepButtonSizeOnLoading ? Alignment.center : null,
      decoration: BoxDecoration(
        shape: keepButtonSizeOnLoading ? BoxShape.rectangle : BoxShape.circle,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: LoadingAnimationWidget.hexagonDots(
          color: Theme.of(context).canvasColor.withValues(alpha: 0.5),
          size: 40.0,
        ),
      ),
    );
  }

  void _setButtonToReady() {
    _isBusy = false;
    _isFirstBuild = false;
    if (mounted) {
      setState(() {
        HapticFeedback.mediumImpact();
      });
    }
  }

  void _setButtonToBusy() {
    _isBusy = true;
    _isFirstBuild = false;
    if (mounted) setState(() {});
  }

  Widget _buildLabelText() {
    switch (widget._labelType) {
      case _DefaultButtonLabelType.verySmall:
        return TitleText.verySmall(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
      case _DefaultButtonLabelType.small:
        return TitleText.small(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
      case _DefaultButtonLabelType.medium:
        return TitleText.medium(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
      case _DefaultButtonLabelType.large:
        return TitleText.large(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
      case _DefaultButtonLabelType.extraLarge:
        return TitleText.extraLarge(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
      default:
        return TitleText(
          text: widget.label!,
          color: widget.labelColor ?? widget.labelStyle.color,
          fontFamily: widget.labelStyle.fontFamily,
          fontWeight: widget.labelStyle.fontWeight ?? FontWeight.w500,
        );
    }
  }
}

enum DefaultButtonIconLocation { Start, End }

class _AnimatedClipRRect extends StatelessWidget {
  const _AnimatedClipRRect({
    required this.duration,
    this.curve = Curves.linear,
    required this.borderRadius,
    required this.child,
    required this.needToAnimate,
    required this.border,
  });

  final Duration duration;
  final Curve curve;
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final bool needToAnimate;
  final Border? border;

  Widget _builder(BuildContext context, BorderRadiusGeometry radius, Widget? child) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, border: border),
      child: ClipRRect(borderRadius: radius, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<BorderRadiusGeometry>(
      duration: duration,
      curve: curve,
      tween: needToAnimate
          ? Tween(begin: BorderRadius.zero, end: borderRadius)
          : Tween(begin: borderRadius, end: borderRadius),
      builder: _builder,
      child: child,
    );
  }
}
