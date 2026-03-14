import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/core/utils/validator.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:reminder_app/features/user/widgets/profile_header.dart';
import 'package:reminder_app/features/user/widgets/profile_form_card.dart';
import 'package:reminder_app/sheared_widgets/others/snack_bar.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const TitleText.small(
          text: 'profile',
          color: AppColors.blueColor,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Subtle gradient header wash
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blueColor.withValues(alpha: isDark ? 0.12 : 0.07),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const _ProfileHeaderIntro(),
                    const SizedBox(height: 28),
                    BlocBuilder<ReminderCubit, ReminderState>(
                      builder: (context, rState) {
                        final reminders = rState.reminder;
                        final activeCount = reminders.where((r) => !r.isCompleted).length;
                        final completedCount = reminders
                            .where((r) => r.isCompleted)
                            .length;
                        final highCount = reminders
                            .where((r) => r.priority.toLowerCase() == 'high')
                            .length;
                        final productivity = reminders.isEmpty
                            ? '0%'
                            : '${((completedCount / reminders.length) * 100).toStringAsFixed(0)}%';
                        return ProfileHeader(
                          nameCtrl: _nameCtrl.text,
                          isDark: isDark,
                          mq: mq,
                          totalActive: activeCount,
                          totalCompleted: completedCount,
                          totalAll: reminders.length,
                          totalHigh: highCount,
                          productivity: productivity,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Section header
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.blueColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TitleText(
                              text: 'edit_profile',
                              subtractedSize: 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ProfileFormCard(
                      formKey: _formKey,
                      nameCtrl: _nameCtrl,
                      nameFocusNode: _nameFocusNode,
                      valid: _valid,
                      formValid: _formValid,
                      onSave: _save,
                    ),
                    const SizedBox(height: 20),
                    const _ProfileHintText(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        // Avatar with ring glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.blueColor.withValues(alpha: 0.25),
                    AppColors.blueColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            // Border ring
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.blueColor.withValues(alpha: 0.35),
                  width: 2.5,
                ),
              ),
            ),
            // Avatar
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.blueColor, AppColors.bluedark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blueColor.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 46),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const TitleText(
          text: 'personalize_your_profile',
          color: AppColors.blueColor,
          subtractedSize: 2,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const SubtitleText(
          text: 'update_name',
          subtractedSize: 5,
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
    return const Opacity(
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
