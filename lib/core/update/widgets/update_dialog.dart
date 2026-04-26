import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import 'package:reminder_app/core/update/cubit/update_cubit.dart';
import 'package:reminder_app/core/update/cubit/update_state.dart';
import 'package:reminder_app/core/utils/app_export.dart';

/// A reusable, premium-styled dialog for managing Shorebird in-app updates.
///
/// Call [UpdateDialog.show] from a `BlocListener` when the state is
/// [UpdateStatus.available], [UpdateStatus.ready], or [UpdateStatus.applied].
class UpdateDialog {
  UpdateDialog._();

  /// Shows the update dialog. Should be called once when an update is detected.
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'update_dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      pageBuilder: (context, _, __) => const _UpdateDialogContent(),
    );
  }
}

class _UpdateDialogContent extends StatelessWidget {
  const _UpdateDialogContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: BlocConsumer<UpdateCubit, UpdateState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == UpdateStatus.upToDate ||
              state.status == UpdateStatus.initial) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.blueColor.withValues(alpha: isDark ? 0.15 : 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blueColor.withValues(alpha: 0.08),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(context, state),
                    const SizedBox(height: 20),
                    _buildTitle(context, state),
                    const SizedBox(height: 10),
                    _buildMessage(context, state),
                    const SizedBox(height: 24),
                    _buildProgress(context, state),
                    const SizedBox(height: 24),
                    _buildActions(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo(BuildContext context, UpdateState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show a success checkmark overlay when the update was silently applied.
    final isApplied = state.status == UpdateStatus.applied;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blueColor.withValues(alpha: isDark ? 0.12 : 0.06),
          ),
          child: ClipOval(
            child: Image.asset(
              AppAssets.appLauncher,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isApplied)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, UpdateState state) {
    String titleKey;
    switch (state.status) {
      case UpdateStatus.downloading:
        titleKey = 'update_downloading_title';
        break;
      case UpdateStatus.ready:
        titleKey = 'update_ready_title';
        break;
      case UpdateStatus.applied:
        titleKey = 'update_applied_title';
        break;
      case UpdateStatus.error:
        titleKey = 'update_error_title';
        break;
      default:
        titleKey = 'update_available_title';
    }
    return TitleText(
      text: titleKey,
      color: AppColors.getTextColor(context),
      subtractedSize: 1,
      fontWeight: FontWeight.w800,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, UpdateState state) {
    String msgKey;
    switch (state.status) {
      case UpdateStatus.downloading:
        msgKey = 'update_downloading_msg';
        break;
      case UpdateStatus.ready:
        msgKey = 'update_restart_msg';
        break;
      case UpdateStatus.applied:
        msgKey = 'update_applied_msg';
        break;
      case UpdateStatus.error:
        msgKey = 'update_error_msg';
        break;
      default:
        msgKey = 'update_available_msg';
    }
    return SubtitleText(
      text: msgKey,
      color: AppColors.getGrayTextColor(context),
      subtractedSize: 2,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProgress(BuildContext context, UpdateState state) {
    if (state.status != UpdateStatus.downloading && state.status != UpdateStatus.ready) {
      return const SizedBox.shrink();
    }

    final progress = state.status == UpdateStatus.ready ? 1.0 : state.downloadProgress;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: state.status == UpdateStatus.downloading ? null : progress,
            minHeight: 6,
            backgroundColor: AppColors.blueColor.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blueColor),
          ),
        ),
        const SizedBox(height: 8),
        SubtitleText(
          text: state.status == UpdateStatus.ready
              ? 'update_progress_complete'.tr()
              : 'update_progress_downloading'.tr(),
          color: AppColors.blueColor,
          subtractedSize: 5,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, UpdateState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (state.status) {
      // ── New patch available for download ──
      case UpdateStatus.available:
      case UpdateStatus.error:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'update_later_btn'.tr(),
                onPressed: () => Navigator.of(context).pop(),
                isPrimary: false,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'update_download_btn'.tr(),
                onPressed: () => context.read<UpdateCubit>().startDownload(),
                isPrimary: true,
                isDark: isDark,
              ),
            ),
          ],
        );

      // ── Download in progress ──
      case UpdateStatus.downloading:
        return SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'update_downloading_btn'.tr(),
            onPressed: null,
            isPrimary: true,
            isDark: isDark,
          ),
        );

      // ── Patch downloaded, restart needed ──
      case UpdateStatus.ready:
        return SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'update_restart_btn'.tr(),
            onPressed: () async {
              // Acknowledge BEFORE restarting so the flag is cleared.
              await context.read<UpdateCubit>().acknowledgeUpdate();
              // Safety delay: ensure SharedPreferences writes are flushed
              // to disk before forceKill terminates the process.
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) Navigator.of(context).pop();
              await Restart.restartApp(forceKill: true);
            },
            isPrimary: true,
            isDark: isDark,
            icon: Icons.restart_alt_rounded,
          ),
        );

      // ── Patch was silently applied by the engine ──
      case UpdateStatus.applied:
        return SizedBox(
          width: double.infinity,
          child: _ActionButton(
            label: 'update_applied_btn'.tr(),
            onPressed: () async {
              // Acknowledge so this dialog doesn't show again.
              await context.read<UpdateCubit>().acknowledgeUpdate();
              if (context.mounted) Navigator.of(context).pop();
            },
            isPrimary: true,
            isDark: isDark,
            icon: Icons.check_circle_outline_rounded,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    required this.isDark,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDark;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    if (!isPrimary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(color: AppColors.blueColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.getTextColor(context),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: AppColors.blueColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.blueColor.withValues(alpha: 0.5),
        disabledForegroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}
