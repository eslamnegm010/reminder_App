import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';
import '../../../../sheared_widgets/others/app_divider.dart';

class SectionTitleText extends StatelessWidget {
  final String text;

  const SectionTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleText(
          subtractedSize: 11,
          text: text,
          fontWeight: FontWeight.w600,
          color: AppColors.blueTextColor(context),
        ),
        const SizedBox(width: 10),
        Expanded(child: AppBarDivider.getAppBarDivider(context)),
      ],
    );
  }
}
