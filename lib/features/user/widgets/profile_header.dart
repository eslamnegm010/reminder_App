import 'package:flutter/material.dart';

import '../../../core/utils/app_export.dart';

class ProfileHeader extends StatelessWidget {
  final String nameCtrl;
  final String emailCtrl;
  final bool isDark;
  final MediaQueryData mq;

  const ProfileHeader({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.isDark,
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    final headerHeight = mq.size.height * 0.20;
    final textColor = AppColors.getTextColor(context);

    final gradientColors = isDark
        ? [
            const Color(0xFF0F2027),
            const Color(0xFF203A43),
            const Color(0xFF2C5364),
          ]
        : [
            const Color(0xFFE3F2FD),
            const Color(0xFFBBDEFB),
            const Color(0xFF90CAF9),
          ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                // ignore: deprecated_member_use
                ? Colors.blueAccent.withOpacity(0.1)
                // ignore: deprecated_member_use
                : Colors.blue.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDark
              // ignore: deprecated_member_use
              ? Colors.blueGrey.shade700.withOpacity(0.4)
              // ignore: deprecated_member_use
              : Colors.blue.shade100.withOpacity(0.6),
          width: 1.1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            right: -40,
            child: Icon(Icons.blur_on,
                color: Colors.white.withOpacity(0.1), size: 120),
          ),
          Positioned(
            bottom: -15,
            left: -40,
            child: Icon(Icons.blur_on,
                color: Colors.white.withOpacity(0.08), size: 100),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(AppAssets.appLauncher, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: TitleText(
                          key: ValueKey(nameCtrl),
                          text: nameCtrl.isEmpty
                              ? 'guest_user'
                              : nameCtrl,
                          subtractedSize: 6,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: SubtitleText(
                          key: ValueKey(emailCtrl),
                          text: emailCtrl.isEmpty ? '—' : emailCtrl,
                          subtractedSize: 1,
                          color: isDark ?
                          Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
