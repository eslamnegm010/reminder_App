import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_cubit.dart';
import 'package:eslam_s_application/features/user/widgets/profile_header.dart';
import 'package:eslam_s_application/features/user/widgets/profile_form_card.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
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
    final changed = (user?.name ?? '') != _nameCtrl.text.trim() ||
        (user?.email ?? '') != _emailCtrl.text.trim();
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

  bool get _formValid {
    final nameValid = Validator().validateUserName(_nameCtrl.text) == null;
    final emailValid = !Validator().isInvalidEmail(_emailCtrl.text);
    return nameValid && emailValid;
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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: TitleText.small(
          text: 'profile',
          color: AppColors.blueColor,
        ),
        centerTitle: true,
      ),
      body: Container(
    
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const _ProfileHeaderIntro(),
                  const SizedBox(height: 30),
                  ProfileHeader(
                    nameCtrl: _nameCtrl.text,
                    emailCtrl: _emailCtrl.text,
                    isDark: isDark,
                    mq: mq,
                  ),
                  const SizedBox(height: 30),
                  ProfileFormCard(
                    formKey: _formKey,
                    nameCtrl: _nameCtrl,
                    emailCtrl: _emailCtrl,
                    nameFocusNode: _nameFocusNode,
                    emailFocusNode: _emailFocusNode,
                    valid: _valid,
                    formValid: _formValid,
                    onSave: _save,
                  ),
                  const SizedBox(height: 24),
                  const _ProfileHintText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderIntro extends StatelessWidget {
  const _ProfileHeaderIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                // ignore: deprecated_member_use
                AppColors.blueColor.withOpacity(0.8),
                // ignore: deprecated_member_use
                AppColors.blueColor.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: AppColors.blueColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 45),
        ),
        const SizedBox(height: 12),
        TitleText(
          text: 'personalize_your_profile',
          color: AppColors.blueColor,
          subtractedSize: 3,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        SubtitleText(
          text:
              'update_name_email',
          color: AppColors.greyColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}






class _ProfileHintText extends StatelessWidget {
  const _ProfileHintText();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: TitleText(
        text: 'profile_edit_hint',
        textAlign: TextAlign.center,
        subtractedSize: 13,
        color: AppColors.greyColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

