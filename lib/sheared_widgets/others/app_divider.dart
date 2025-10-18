import 'package:flutter/material.dart';

class AppBarDivider extends StatelessWidget {
  const AppBarDivider({super.key, this.indent = 10});
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: indent,
      indent: indent,
      color: Theme.of(context).canvasColor.withOpacity(.8),
      height: .5,
      thickness: 0.6,
    );
  }

  static Divider getAppBarDivider(context) {
    return Divider(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      height: .5,
      thickness: 0.6,
    );
  }
}
