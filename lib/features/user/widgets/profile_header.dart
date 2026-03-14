import 'package:flutter/material.dart';

import '../../../core/utils/app_export.dart';
import '../../reminder/pages/productivity_dashboard.dart';

class ProfileHeader extends StatelessWidget {
  final String nameCtrl;
  final bool isDark;
  final MediaQueryData mq;
  final int totalActive;
  final int totalCompleted;
  final int totalAll;
  final int totalHigh;
  final String productivity;

  const ProfileHeader({
    super.key,
    required this.nameCtrl,
    required this.isDark,
    required this.mq,
    this.totalActive = 0,
    this.totalCompleted = 0,
    this.totalAll = 0,
    this.totalHigh = 0,
    this.productivity = '0%',
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;
    final gradientColors = isDark
        ? [const Color(0xFF1a2a6c), const Color(0xFF2193b0), const Color(0xFF6dd5ed)]
        : [const Color(0xFF2193b0), const Color(0xFF6dd5ed)];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.blue).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Positioned(
              top: -20.h,
              right: -20.h,
              child: Directionality(
                textDirection: Directionality.of(context),
                child: Icon(
                  Icons.circle_outlined,
                  color: Colors.white.withValues(alpha: 0.1),
                  size: 150,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.8),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.2),
                            child: Image.asset(AppAssets.appLauncher, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TitleText(
                              text: nameCtrl.isEmpty ? 'guest_user' : nameCtrl,
                              subtractedSize: 6,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              maxLines: null,
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TitleText(
                                text: nameCtrl.isEmpty ? 'guest' : 'pro_user',
                                subtractedSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TitleText(
                              text: 'profile_motto',
                              subtractedSize: 12,
                              maxLines: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductivityDashboard(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insights_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              TitleText(
                                text: "view_insights",
                                subtractedSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 24),
                  TitleText(
                    text: 'stats_overview',
                    subtractedSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    padding: const EdgeInsets.only(bottom: 8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem("active", totalActive.toString(), textColor),
                      _buildStatDivider(),
                      _buildStatItem("completed", totalCompleted.toString(), textColor),
                      _buildStatDivider(),
                      _buildStatItem("high", totalHigh.toString(), textColor),
                      _buildStatDivider(),
                      _buildStatItem("all", totalAll.toString(), textColor),
                      _buildStatDivider(),
                      _buildStatItem("productivity", productivity, textColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() => Container(width: 1, height: 25, color: Colors.white24);

  Widget _buildStatItem(String label, String value, Color textColor) {
    return Expanded(
      child: Column(
        children: [
          TitleText(
            text: value,
            subtractedSize: 10,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
          TitleText(
            text: label,
            subtractedSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}
