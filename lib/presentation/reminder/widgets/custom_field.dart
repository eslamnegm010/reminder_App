import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eslam_s_application/presentation/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';

class AddReminderField extends StatefulWidget {
  const AddReminderField({super.key});

  @override
  State<AddReminderField> createState() => _AddReminderFieldState();
}

class _AddReminderFieldState extends State<AddReminderField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    _controller = TextEditingController();
    _focus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ReminderCubit>().addReminder(text: _controller.text.trim());
      _controller.clear();
      _focus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Form(
          key: _formKey,
          child: DefaultTextFormField(
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "please_enter_reminder".tr();
              }
              return null;
            },
            onSubmitted: (_) => _submit(),
            currentFocusNode: _focus,
            hint: 'add_your_reminder'.tr(),
            currentController: _controller,
            borderRadius: 20,
            contentPadding: const EdgeInsets.all(10),
            textColor:
                isDarkMode ? AppColors.graylightText : AppColors.grayDarkText,
            borderColor: isDarkMode ? AppColors.blueColor : null,
            fillColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submit,
            child: const TitleText.verySmall(text: "add", color: Colors.white),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.blueColor),
            ),
          ),
        ),
      ],
    );
  }
}
