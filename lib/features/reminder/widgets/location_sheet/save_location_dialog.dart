import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/features/reminder/cubit/location_picker_cubit.dart';
import 'package:eslam_s_application/res/theme/app_colors.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> showSaveLocationDialog(
  BuildContext context,
  LocationPickerCubit cubit,
) async {
  final nameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      title: TitleText(
        text: 'name_this_location'.tr(),
        subtractedSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextColor(context),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextFormField(
            currentController: nameController,
            currentFocusNode: FocusNode(),
            hint: 'e.g., Home, Work, Gym',
            hintStyle: TextStyle(
              color: AppColors.getGrayTextColor(context),
              fontSize: 14,
            ),
            textColor: AppColors.getTextColor(context),
            fillColor: Colors.transparent,
            borderColor: AppColors.blueColor.withValues(alpha: 0.2),
            borderRadius: 12,
            autofocus: true,
            validator: null,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: TitleText(
                    text: 'cancel'.tr(),
                    color: AppColors.getGrayTextColor(context),
                    fontWeight: FontWeight.w600,
                    subtractedSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultButton(
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty) {
                      try {
                        final name = nameController.text.trim();
                        await cubit.saveCustomLocation(name, context);
                        if (context.mounted) Navigator.pop(ctx);

                        final result = LocationSearchResult(
                          displayName: name,
                          type: 'saved',
                          location: cubit.state.pickedLocation!,
                          address: {},
                        );
                        if (context.mounted) Navigator.pop(context, result);
                        if (context.mounted) {
                          showSnackbar(context, message: 'Location saved as "$name"');
                        }
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        if (context.mounted) {
                          showSnackbar(context, message: 'Failed to save: $e');
                        }
                      }
                    }
                  },
                  backgroundColor: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  labelWidget: TitleText(
                    text: 'save'.tr(),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    subtractedSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
