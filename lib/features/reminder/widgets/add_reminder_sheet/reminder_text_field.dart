import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';
import '../../../../sheared_widgets/text_field/default_text_form_field.dart';

class ReminderTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?) validator;
  final bool isDarkMode;
  final int maxLines;
  final bool isRequired;

  const ReminderTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.isDarkMode,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      currentController: controller,
      currentFocusNode: focusNode,
      hint: "type_here..",
      isRequired: isRequired,
      maxLines: maxLines,
      validator: validator,
      borderRadius: 14,
      hintColor: AppColors.grayDarkText,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      textColor: AppColors.getTextColor(context),
      borderColor: AppColors.blueColor.withValues(alpha: 0.16),
      fillColor: Colors.transparent,
    );
  }
}
