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

  const ProfileFormCard({
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

    return Card(
      color: AppColors.getCardBackgroundColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DefaultTextFormField(
                currentController: nameCtrl,
                currentFocusNode: nameFocusNode,
                hint: 'full_name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: Validator().validateUserName,
                borderRadius: 12,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                textColor: textColor,
                hintColor: AppColors.grayDarkText,
                fillColor: Colors.transparent,
                // ignore: deprecated_member_use
                borderColor: AppColors.blueColor.withValues(alpha: 0.25),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: DefaultButton.verySmall(
                      label: 'cancel'.tr().toUpperCase(),
                      backgroundColor: AppColors.redColor,
                      labelColor: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: UIConstants.marginLarge),
                  Expanded(
                    child: DefaultButton.verySmall(
                      backgroundColor: valid && formValid
                          ? AppColors.blueColor
                          : AppColors.Bordergrey,
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
    );
  }
}
