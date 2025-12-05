import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';
import '../../../../sheared_widgets/default_button.dart';

class ReminderActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color labelColor;

  const ReminderActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.blueColor,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultButton.verySmall(
      label: label,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
    );
  }
}
