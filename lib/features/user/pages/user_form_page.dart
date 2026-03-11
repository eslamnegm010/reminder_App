import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/core/utils/validator.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:reminder_app/features/user/widgets/profile_header.dart';
import 'package:reminder_app/features/user/widgets/profile_form_card.dart';
import 'package:reminder_app/sheared_widgets/others/snack_bar.dart';
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
  late final FocusNode _nameFocusNode;
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserCubit>().state.user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _nameFocusNode = FocusNode();
    _nameCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final user = context.read<UserCubit>().state.user;
    final changed = (user?.name ?? '') != _nameCtrl.text.trim();
    if (changed != _valid) {
      setState(() => _valid = changed);
    }
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_onFieldChanged);
    _nameCtrl.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  bool get _formValid {
    final nameValid = Validator().validateUserName(_nameCtrl.text) == null;
    return nameValid;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    context.read<UserCubit>().saveUser(name: name);
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
        title: TitleText.small(text: 'profile', color: AppColors.blueColor),
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
                  ProfileHeader(nameCtrl: _nameCtrl.text, isDark: isDark, mq: mq),
                  const SizedBox(height: 30),
                  ProfileFormCard(
                    formKey: _formKey,
                    nameCtrl: _nameCtrl,
                    nameFocusNode: _nameFocusNode,
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
                AppColors.blueColor.withValues(alpha: 0.8),
                AppColors.blueColor.withValues(alpha: 0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blueColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 45),
        ),
        const SizedBox(height: 12),
        const TitleText(
          text: 'personalize_your_profile',
          color: AppColors.blueColor,
          subtractedSize: 3,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const SubtitleText(
          text: 'update_name',
          subtractedSize: 6,
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
        text: 'profile_edit_hint_name',
        textAlign: TextAlign.center,
        subtractedSize: 13,
        color: AppColors.greyColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
