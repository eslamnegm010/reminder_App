import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_cubit.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;

  bool _valid = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserCubit>().state.user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    _nameCtrl.addListener(_onFieldChanged);
    _emailCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final user = context.read<UserCubit>().state.user;
    final changed = (user?.name ?? '') != _nameCtrl.text.trim() || (user?.email ?? '') != _emailCtrl.text.trim();
    if (changed != _valid) {
      setState(() => _valid = changed);
    }
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_onFieldChanged);
    _emailCtrl.removeListener(_onFieldChanged);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  bool get _formValid {
    // quick validation check without showing errors
    final nameValid = Validator().validateUserName(_nameCtrl.text) == null;
    final emailValid = !Validator().isInvalidEmail(_emailCtrl.text);
    return nameValid && emailValid;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerHeight = mq.size.height * 0.20;
    final textColor = AppColors.getTextColor(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TitleText.small(
          text: 'profile',
          color: AppColors.blueColor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            children: [
              const SizedBox(height: UIConstants.marginLarge * 1.5),

              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: headerHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blueColor.withOpacity(0.08),
                      AppColors.getCardBackgroundColor(context),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: AppColors.blueColor.withOpacity(0.06)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Avatar & edit
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: (headerHeight / 2) - 28,
                            backgroundColor: AppColors.greyColor,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _nameCtrl.text.trim().isEmpty
                                  ? SvgPicture.asset(
                                      AppAssets.userCircleIcon,
                                      key: const ValueKey('svg'),
                                      colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                                      height: 44,
                                      width: 44,
                                    )
                                  : TitleText(
                                      text: _initials(_nameCtrl.text),
                                      key: ValueKey(_nameCtrl.text),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      subtractedSize: 5,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Material(
                              color: AppColors.blueColor,
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Change avatar (not implemented)')),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.edit, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),
                      // Live preview
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: TitleText(
                                key: ValueKey(_nameCtrl.text),
                                text: _nameCtrl.text.isEmpty ? 'guest_user' : _nameCtrl.text,
                                subtractedSize: 6,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: SubtitleText(
                                key: ValueKey(_emailCtrl.text),
                                text: _emailCtrl.text.isEmpty ? '—' : _emailCtrl.text,
                                subtractedSize: 1,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.marginLarge),

              // Form card
              Card(
                color: AppColors.getCardBackgroundColor(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          currentController: _nameCtrl,
                          currentFocusNode: _nameFocusNode,
                          hint: 'full_name',
                          validator: (v) => Validator().validateUserName(v ?? ''),
                          borderRadius: 12,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          textColor: textColor,
                          borderColor: AppColors.blueColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 12),
                        DefaultTextFormField(
                          currentController: _emailCtrl,
                          currentFocusNode: _emailFocusNode,
                          hint: 'email',
                          validator: (v) => Validator().isInvalidEmail(v ?? '') ? 'invalid email' : null,
                          borderRadius: 12,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          textColor: textColor,
                          borderColor: AppColors.blueColor.withOpacity(0.2),
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
                                backgroundColor: _valid && _formValid ? AppColors.blueColor : AppColors.Bordergrey,
                                label: 'save'.tr().toUpperCase(),
                                labelColor: Colors.white,
                                onPressed: _valid && _formValid ? _save : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Opacity(
                opacity: 0.8,
                child: TitleText(
                  text: 'profile_edit_hint',
                  textAlign: TextAlign.center,
                  subtractedSize: 13,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    context.read<UserCubit>().saveUser(name: name, email: email);
    showSnackbar(context, message: 'profile_saved_successfully');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.remainderPage);
  }
}
