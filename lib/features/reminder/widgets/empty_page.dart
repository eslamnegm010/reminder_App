import 'package:reminder_app/core/utils/app_export.dart';
import 'package:flutter/material.dart';

ListView buildEmptyList() => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 80.h),
        const AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          child: Column(
            key: ValueKey('empty'),
            children: [
              Icon(Icons.event_note_rounded, size: 72, color: AppColors.greyColor),
              SizedBox(height: 12),
              TitleText.verySmall(text: 'no_reminder_yet', color: AppColors.blueColor),
              SizedBox(height: 6),
              Text('Tap + to add your first reminder', style: TextStyle(color: AppColors.grayDarkText)),
            ],
          ),
        ),
      ],
    );
