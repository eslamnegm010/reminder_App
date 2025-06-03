
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/main_text_form_field.dart';
import 'package:flutter/material.dart';

class DefaultTextFormField extends MainTextFormField {
  DefaultTextFormField({
    super.key,
    required super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    required final String hint,
    super.keyboardType,
    super.margin = null,
    super.contentPadding,
    super.enabled,
    final bool isRequired = false,
    super.expanded,
    bool super.readOnly = false,
    super.maxLines = 1,
    super.obscureText,
    super.isOutlineInputBorder,
    super.suffixIcon,
    super.prefixIcon,
    super.fillColor,
    super.hintColor,
    super.textColor,
    super.borderColor,
    final double borderRadius = 10,
    super.textCapitalization = TextCapitalization.sentences,
    final String? Function(String?)? validator,
    super.onChanged,
    super.autofillHints,
    final ValueChanged<String>? onSubmitted,
    super.onTap,
    super.fontWeight, 
    double? borderWidth,
    super.cursorHeight,
    super.autovalidateMode,
  }) : super(
            validator: validator ??
                (isRequired ? Validator().validateEmptyField : null),
            hintText: hint,
            borderRadius: BorderRadius.circular(borderRadius),
            onTapOutside: currentFocusNode?.unfocus,
            onFieldSubmitted: onSubmitted);
}
