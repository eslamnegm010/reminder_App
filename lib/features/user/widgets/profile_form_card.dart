import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/validator.dart';
import 'package:reminder_app/sheared_widgets/default_button.dart';
import 'package:reminder_app/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_export.dart';

class ProfileFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final FocusNode nameFocusNode;
  final bool valid;
  final bool formValid;
  final VoidCallback onSave;

  const ProfileFormCard({super.key, 
    required this.formKey,
    required this.nameCtrl,
    required this.nameFocusNode,
    required this.valid,
    required this.formValid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.getTextColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.blueColor.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : AppColors.blueColor.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(height: 3, color: AppColors.blueColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 16, color: AppColors.blueColor),
                          const SizedBox(width: 6),
                          TitleText(
                            text: 'full_name',
                            subtractedSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueColor,
                          ),
                        ],
                      ),
                    ),
                    DefaultTextFormField(
                      currentController: nameCtrl,
                      currentFocusNode: nameFocusNode,
                      hint: 'full_name',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: Validator().validateUserName,
                      borderRadius: 14,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      textColor: textColor,
                      hintColor: AppColors.grayDarkText,
                      fillColor: Colors.transparent,
                      borderColor: AppColors.blueColor.withValues(alpha: 0.25),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultButton.verySmall(
                            label: 'cancel'.tr().toUpperCase(),
                            backgroundColor: isDark
                                ? Colors.white12
                                : Colors.grey.shade200,
                            labelColor: textColor,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: UIConstants.marginLarge),
                        Expanded(
                          child: DefaultButton.verySmall(
                            backgroundColor: valid && formValid
                                ? AppColors.blueColor
                                : AppColors.blueColor.withValues(alpha: 0.3),
                            label: 'save'.tr().toUpperCase(),
                            labelColor: Colors.white,
                            onPressed: valid && formValid ? onSave : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
