import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/res/theme/app_colors.dart';

class LocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;
  final bool isSearching;

  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onChanged,
    required this.onSubmitted,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.2)),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'search_location'.tr(),
                hintStyle: TextStyle(color: AppColors.getGrayTextColor(context)),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.blueColor),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.getGrayTextColor(context),
                        ),
                        onPressed: onClear,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
          if (isSearching) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: LinearProgressIndicator(
        minHeight: 3,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(AppColors.blueColor),
      ),
    );
  }
}
