import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';

class ReminderSearchDelegate extends SearchDelegate<String> {
  final void Function(String) onQueryUpdate;
  ReminderSearchDelegate({required this.onQueryUpdate});

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, ''), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    onQueryUpdate(query);
    close(context, query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryUpdate(query);
    return Center(
        child: TitleText.verySmall(text: query.isEmpty ? 'type_to_search' : 'searching_for'.tr(args: [query])));
  }
}
