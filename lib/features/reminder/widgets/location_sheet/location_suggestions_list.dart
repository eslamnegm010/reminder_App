/*
import 'package:reminder_app/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/res/theme/app_colors.dart';
import 'package:reminder_app/core/location_services/models/location_model.dart';

class LocationSuggestionsList extends StatelessWidget {
  final List<LocationSearchResult> suggestions;
  final ValueChanged<LocationSearchResult> onSelect;

  const LocationSuggestionsList({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => Divider(
          color: AppColors.getGrayTextColor(context).withValues(alpha: 0.1),
          height: 1,
        ),
        itemBuilder: (ctx, i) => _buildSuggestionTile(ctx, suggestions[i]),
      ),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, LocationSearchResult result) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.blueColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.location_on_outlined, color: AppColors.blueColor, size: 20),
      ),
      title: TitleText(
        text: result.displayName,
        maxLines: 2,
        subtractedSize: 11,
        color: AppColors.getTextColor(context),
        fontWeight: FontWeight.w600,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppColors.blueColor,
      ),
      onTap: () => onSelect(result),
    );
  }
}
*/
