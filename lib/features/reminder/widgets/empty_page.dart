import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:flutter/material.dart';

ListView buildEmptyList() => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 80.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Column(
            key: const ValueKey('empty'),
            children: [
              Icon(Icons.event_note_rounded, size: 72, color: AppColors.greyColor),
              const SizedBox(height: 12),
              TitleText.verySmall(text: 'no_reminder_yet', color: AppColors.blueColor),
              const SizedBox(height: 6),
              Text('Tap + to add your first reminder', style: TextStyle(color: AppColors.grayDarkText)),
            ],
          ),
        ),
      ],
    );
