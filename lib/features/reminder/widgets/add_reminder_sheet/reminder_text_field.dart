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
      borderRadius: 16,
      hintColor: isDarkMode
          ? Colors.white38
          : AppColors.grayDarkText.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      textColor: AppColors.getTextColor(context),
      borderColor: isDarkMode
          ? Colors.white.withValues(alpha: 0.08)
          : AppColors.blueColor.withValues(alpha: 0.1),
      fillColor: isDarkMode ? Colors.white.withValues(alpha: 0.03) : Colors.transparent,
    );
  }
}
