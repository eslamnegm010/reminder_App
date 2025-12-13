import 'package:reminder_app/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';

class DismissibleWrapper extends StatelessWidget {
  final String id;
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final bool isCompleted;

  const DismissibleWrapper({
    super.key,
    required this.id,
    required this.child,
    required this.onDelete,
    required this.onComplete,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: isCompleted ? DismissDirection.endToStart : DismissDirection.horizontal,
      background: isCompleted ? const SizedBox() : _buildActionBackground(isLeft: true),
      secondaryBackground: _buildActionBackground(isLeft: false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd && !isCompleted) {
          onComplete();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          onDelete();
          return true;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: child,
    );
  }

  Widget _buildActionBackground({required bool isLeft}) {
    final color = isLeft ? Colors.green : Colors.red;
    final icon = isLeft ? Icons.check_circle : Icons.delete_forever;
    final alignment = isLeft ? Alignment.centerLeft : Alignment.centerRight;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeft) ...[
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 8),
            const TitleText(
              subtractedSize: 12,
              text: 'mark_as_done',
              color: Colors.white,
            ),
          ] else ...[
            const TitleText(
              subtractedSize: 12,
              text: 'delete',
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 26),
          ],
        ],
      ),
    );
  }
}
