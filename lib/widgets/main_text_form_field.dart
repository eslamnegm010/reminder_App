import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:size_helper/size_helper.dart';

import '../res/theme/theme_helper.dart';

abstract class MainTextFormField extends StatefulWidget {
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool expanded;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final Color? hintColor;
  final bool enableSuggestions;
  final bool showScrollbar;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? fillColor;
  final Color? cursorColor;
  final TextStyle? style;
  final Color? textColor;
  final void Function()? onTap;
  final bool? readOnly;
  final bool isOutlineInputBorder;
  final BorderRadius? borderRadius;
  final Function()? onEditingComplete;
  final Function()? onTapOutside;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final double? cursorHeight;
  final AutovalidateMode? autovalidateMode;
  final bool? autofocus;
  const MainTextFormField(
      {super.key,
      required this.currentFocusNode,
      this.nextFocusNode,
      required this.currentController,
      required this.hintText,
      this.keyboardType,
      this.textInputAction,
      required this.validator,
      this.textCapitalization = TextCapitalization.none,
      this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      this.enabled = true,
      this.maxLength,
      this.inputFormatters,
      this.expanded = false,
      this.maxLines,
      this.contentPadding,
      this.borderColor,
      this.hintColor,
      this.enableSuggestions = false,
      this.showScrollbar = false,
      this.obscureText,
      this.suffixIcon,
      this.onChanged,
      this.onFieldSubmitted,
      this.fillColor,
      this.cursorColor,
      this.style,
      this.prefixIcon,
      this.textColor,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.autofillHints,
      this.readOnly,
      this.isOutlineInputBorder = true,
      this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
      this.textAlign = TextAlign.start,
      this.fontWeight,
      this.cursorHeight,
      this.autovalidateMode,
      this.autofocus = false});

  @override
  MainTextFormFieldState createState() => MainTextFormFieldState();
}

class MainTextFormFieldState extends State<MainTextFormField> {
  TextDirection? _currentDir;
  static const borderWidth = 1.0;
  @override
  Widget build(BuildContext context) {
    final arabic = context.locale == const Locale('ar');
    _currentDir ??= arabic ? TextDirection.rtl : TextDirection.ltr;
    final textTheme = Theme.of(context).textTheme;

    Widget textFieldWidget = TextFormField(
      cursorHeight: widget.cursorHeight,
      readOnly: widget.readOnly ?? false,
      autofocus: widget.autofocus ?? false,
      autovalidateMode: widget.autovalidateMode,
      onTap: () {
        var selection = widget.currentController.selection;
        var length = widget.currentController.text.length;
        var isLast = selection ==
            TextSelection.fromPosition(TextPosition(offset: length - 1));
        if (isLast) {
          selection = TextSelection.fromPosition(TextPosition(offset: length));
        }
        if (widget.onTap != null) widget.onTap!();
      },
      cursorColor: widget.cursorColor ??
          widget.textColor ??
          Theme.of(context).canvasColor,
      autofillHints: widget.autofillHints,
      textDirection: _currentDir,
      focusNode: widget.currentFocusNode,
      controller: widget.currentController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      expands: widget.expanded,
      enableSuggestions: widget.enableSuggestions,
      style: widget.style ??
          context
              .sizeHelper(
                mobileLarge: textTheme.bodySmall!
                    .copyWith(fontSize: arabic ? 12.0 : 10.0),
                tabletSmall: textTheme.bodyMedium!
                    .copyWith(fontSize: arabic ? 16.0 : 14.0),
                tabletNormal: textTheme.bodySmall!
                    .copyWith(fontSize: arabic ? 20.0 : 18.0),
                desktopSmall: textTheme.bodySmall!
                    .copyWith(fontSize: arabic ? 22.0 : 20.0),
                desktopExtraLarge: textTheme.bodySmall!
                    .copyWith(fontSize: arabic ? 24.0 : 22.0),
              )
              .copyWith(
                  color: widget.textColor ?? Theme.of(context).canvasColor,
                  fontWeight: widget.fontWeight),
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      textAlignVertical:
          widget.expanded ? const TextAlignVertical(y: -0.8) : null,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        fillColor: widget.enabled
            ? widget.fillColor ?? Colors.white
            : widget.fillColor,
        filled: true,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
        hintText: widget.hintText.tr(),
        alignLabelWithHint: true,
        hintStyle: context
            .sizeHelper(
              // mobileLarge: textTheme.bodySmall!.copyWith(fontSize: 16.0),
              // tabletSmall: textTheme.bodyMedium!.copyWith(fontSize: 16.0),
              // tabletNormal: textTheme.bodySmall!.copyWith(fontSize: 16.0),
              // desktopSmall: textTheme.bodySmall!.copyWith(fontSize: 24.0),
              // desktopExtraLarge: textTheme.bodySmall!.copyWith(fontSize: 26.0),
              mobileLarge:
                  textTheme.bodySmall!.copyWith(fontSize: arabic ? 12.0 : 10.0),
              tabletSmall: textTheme.bodyMedium!
                  .copyWith(fontSize: arabic ? 16.0 : 14.0),
              tabletNormal:
                  textTheme.bodySmall!.copyWith(fontSize: arabic ? 20.0 : 18.0),
              desktopSmall:
                  textTheme.bodySmall!.copyWith(fontSize: arabic ? 22.0 : 20.0),
              desktopExtraLarge:
                  textTheme.bodySmall!.copyWith(fontSize: arabic ? 24.0 : 22.0),
            )
            .copyWith(
                color: widget.hintColor ??
                    widget.borderColor ??
                    AppColors.greyColor,
                fontWeight: FontWeight.bold),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        enabledBorder: (widget.isOutlineInputBorder
                ? OutlineInputBorder.new
                : UnderlineInputBorder.new)(
            borderRadius: widget.isOutlineInputBorder
                ? widget.borderRadius ?? BorderRadius.zero
                : BorderRadius.zero,
            borderSide: BorderSide(
              color:
                  widget.borderColor ?? Theme.of(context).secondaryHeaderColor,
              width: borderWidth,
            )),
        focusedBorder: (widget.isOutlineInputBorder
            ? OutlineInputBorder.new
            : UnderlineInputBorder.new)(
          borderRadius: widget.isOutlineInputBorder
              ? widget.borderRadius ?? BorderRadius.zero
              : BorderRadius.zero,
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).secondaryHeaderColor,
            width: borderWidth,
          ),
        ),
        errorBorder: (widget.isOutlineInputBorder
            ? OutlineInputBorder.new
            : UnderlineInputBorder.new)(
          borderSide: const BorderSide(
            color: Colors.red,
            width: borderWidth,
          ),
          borderRadius: widget.isOutlineInputBorder
              ? widget.borderRadius ?? BorderRadius.zero
              : BorderRadius.zero,
        ),
        focusedErrorBorder: (widget.isOutlineInputBorder
            ? OutlineInputBorder.new
            : UnderlineInputBorder.new)(
          borderSide: const BorderSide(
            color: Colors.red,
            width: borderWidth,
          ),
          borderRadius: widget.isOutlineInputBorder
              ? widget.borderRadius ?? BorderRadius.zero
              : BorderRadius.zero,
        ),
        counterText: '',
        border: InputBorder.none,
        disabledBorder: (widget.isOutlineInputBorder
            ? OutlineInputBorder.new
            : UnderlineInputBorder.new)(
          borderRadius: widget.isOutlineInputBorder
              ? widget.borderRadius ?? BorderRadius.zero
              : BorderRadius.zero,
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).secondaryHeaderColor,
            width: borderWidth,
          ),
        ),
      ),
      validator: widget.validator,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (text) {
        if (text.isEmpty)
          setState(() => _currentDir = null);
        else {
          final dir = _getDirection(text);
          if (dir != _currentDir) setState(() => _currentDir = dir);
        }
        (widget.onChanged ?? (_) {})(text);
      },
      onFieldSubmitted: (String value) {
        if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!(value);
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
      onTapOutside: (event) {
        widget.onTapOutside?.call();
      },
    );

    if (widget.showScrollbar)
      textFieldWidget = Scrollbar(child: textFieldWidget);

    return widget.margin != null
        ? Padding(
            padding: widget.margin!,
            child: textFieldWidget,
          )
        : textFieldWidget;
  }

  TextDirection _getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
