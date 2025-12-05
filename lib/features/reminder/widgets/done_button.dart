import 'package:eslam_s_application/sheared_widgets/others/particle_painter.dart';
import 'package:flutter/material.dart';

class DoneButton extends StatefulWidget {
  final bool isCompleted;
  final Color color;
  final ValueChanged<bool> onToggle;

  const DoneButton({
    Key? key,
    required this.isCompleted,
    required this.color,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _triggerParticles(BuildContext context, Offset position) {
    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: position.dx - 30,
        top: position.dy - 30,
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: ParticlePainter(progress: _controller.value, color: widget.color),
              size: const Size(60, 60),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(from: 0).whenComplete(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (!widget.isCompleted) _triggerParticles(context, details.globalPosition);
        widget.onToggle(!widget.isCompleted);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.isCompleted
              ? LinearGradient(
                  colors: [widget.color.withValues(alpha: 0.9), widget.color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.isCompleted ? null : Theme.of(context).cardColor,
          border: Border.all(
            color: widget.isCompleted
                ? widget.color
                : Colors.grey.withValues(alpha: 0.18),
            width: 1.2,
          ),
        ),
        child: Center(
          child: widget.isCompleted
              ? const Icon(Icons.check, size: 20, color: Colors.white)
              : Icon(Icons.circle_outlined, size: 18, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
