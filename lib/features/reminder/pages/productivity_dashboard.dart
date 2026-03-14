import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_state.dart';
import 'package:reminder_app/features/reminder/enum/reminder_category.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';

class ProductivityDashboard extends StatelessWidget {
  const ProductivityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        final reminders = state.reminder;
        final completedReminders = reminders.where((r) => r.isCompleted).toList();
        final activeReminders = reminders.where((r) => !r.isCompleted).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: TitleText(
              text: "productivity_insight".tr(),
              subtractedSize: 8,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(context),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSummaryHeader(
                completedReminders.length,
                activeReminders.length,
                context,
              ),
              const SizedBox(height: 24),
              _buildChartCard(
                title: "weekly_trend".tr(),
                chart: _buildWeeklyTrendChart(completedReminders, context),
                context: context,
              ),
              const SizedBox(height: 24),
              _buildChartCard(
                title: "category_distribution".tr(),
                chart: _buildCategoryPieChart(reminders, context),
                context: context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryHeader(int completed, int active, BuildContext context) {
    const primaryGradient = LinearGradient(
      colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2193b0).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("completed".tr(), completed.toString(), Colors.white),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem("active".tr(), active.toString(), Colors.white70),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        TitleText(
          text: value,
          subtractedSize: 2,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        TitleText(text: label, subtractedSize: 14, color: color.withValues(alpha: 0.7)),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required Widget chart,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: title,
            subtractedSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendChart(List<ReminderModel> completed, BuildContext context) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    final spots = last7Days.asMap().entries.map((e) {
      final date = e.value;
      final count = completed
          .where(
            (r) =>
                r.dateTime != null &&
                r.dateTime!.year == date.year &&
                r.dateTime!.month == date.month &&
                r.dateTime!.day == date.day,
          )
          .length;
      return FlSpot(e.key.toDouble(), count.toDouble());
    }).toList();

    const chartGradient = LinearGradient(colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)]);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= last7Days.length)
                  return const SizedBox();
                final date = last7Days[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('E').format(date).substring(0, 1),
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: chartGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2193b0).withValues(alpha: 0.3),
                  const Color(0xFF2193b0).withValues(alpha: 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart(List<ReminderModel> reminders, BuildContext context) {
    if (reminders.isEmpty)
      return Center(
        child: Text(
          "No data yet",
          style: TextStyle(color: AppColors.getTextColor(context)),
        ),
      );

    final categoryCounts = <ReminderCategory, int>{};
    for (var r in reminders) {
      final cat = ReminderCategoryExtension.fromText(r.category);
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
    }

    final sections = categoryCounts.entries.map((e) {
      return PieChartSectionData(
        color: e.key.color,
        value: e.value.toDouble(),
        title: '${(e.value / reminders.length * 100).toInt()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 40),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryCounts.keys.map((cat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.getTextColor(context),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
