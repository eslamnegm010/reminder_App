import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';

class RepeatSelectorCard extends StatelessWidget {
  final String selectedRepeatType;
  final ValueChanged<String> onChanged;
  final bool isDarkMode;

  const RepeatSelectorCard({
    super.key,
    required this.selectedRepeatType,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final repeatTypes = ['None', 'Daily', 'Weekly', 'Monthly'];
    final selectedIndex = repeatTypes.indexOf(selectedRepeatType);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final itemWidth = totalWidth / repeatTypes.length;

        return Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.getCardBackgroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.white12 : Colors.black12),
          ),
          child: Stack(
            children: [
              // Animated Indicator
              AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                start: selectedIndex * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blueColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Items overlay
              Row(
                children: List.generate(repeatTypes.length, (index) {
                  final type = repeatTypes[index];
                  final isSelected = type == selectedRepeatType;

                  IconData icon;
                  if (type == 'None') {
                    icon = Icons.block;
                  } else if (type == 'Daily') {
                    icon = Icons.calendar_today;
                  } else if (type == 'Weekly') {
                    icon = Icons.calendar_view_week;
                  } else {
                    icon = Icons.calendar_month;
                  }

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(type),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Outfit',
                            color: isSelected
                                ? Colors.white
                                : isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                              const SizedBox(width: 4),
                              Text(type.tr()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
