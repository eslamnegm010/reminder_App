// import 'dart:ui' as ui;
// import 'package:easy_localization/easy_localization.dart';
// import 'package:eslam_s_application/core/utils/app_export.dart';
// import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
// import 'package:flutter/material.dart';
// import 'done_button.dart';

// class ReminderCard extends StatelessWidget {
//   final ReminderModel reminder;
//   final VoidCallback onDelete;
//   final ValueChanged<bool?> onToggleCompletion;

//   const ReminderCard({
//     Key? key,
//     required this.reminder,
//     required this.onDelete,
//     required this.onToggleCompletion,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final textColor = AppColors.getTextColor(context);
//     final priorityColor = _priorityColor(reminder.priority);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   priorityColor.withOpacity(0.12),
//                   AppColors.getCardBackgroundColor(context).withOpacity(0.85),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.12),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//               border: Border.all(
//                 color: priorityColor.withOpacity(0.14),
//                 width: 1.0,
//               ),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 splashFactory: InkRipple.splashFactory,
//                 borderRadius: BorderRadius.circular(18),
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 5,
//                         height: 90.h,
//                         decoration: BoxDecoration(
//                           color: priorityColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       DoneButton(
//                         isCompleted: reminder.isCompleted,
//                         color: priorityColor,
//                         onToggle: (value) => onToggleCompletion(value),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               reminder.title,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: reminder.isCompleted ? priorityColor : textColor,
//                                 decoration: reminder.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             if (reminder.description.isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 6, bottom: 6),
//                                 child: Text(
//                                   reminder.description,
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: textColor.withOpacity(0.78),
//                                     height: 1.2,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 6,
//                               children: [
//                                 if (reminder.location != null && reminder.location!.isNotEmpty)
//                                   _infoChip(
//                                     icon: Icons.location_on_outlined,
//                                     text: reminder.location!,
//                                     bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
//                                     iconColor: Colors.teal,
//                                   ),
//                                 if (reminder.dateTime != null)
//                                   _infoChip(
//                                     icon: Icons.free_cancellation_outlined,
//                                     text: DateFormat('MMM d, yyyy • hh:mm a').format(reminder.dateTime!),
//                                     bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
//                                     iconColor: AppColors.getTextColor(context).withOpacity(.6),
//                                   ),
//                                 _infoChip(
//                                   icon: Icons.flag_circle_sharp,
//                                   text: reminder.priority,
//                                   bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
//                                   iconColor: _priorityColor(reminder.priority),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit_notifications, color: AppColors.blueColor),
//                             onPressed: () {
//                               // Handle edit action
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete_rounded, color: AppColors.redColor),
//                             onPressed: onDelete,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoChip({
//     required IconData icon,
//     required String text,
//     required Color bgColor,
//     required Color iconColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: iconColor),
//           const SizedBox(width: 6),
//           Flexible(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: iconColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _priorityColor(String priority) {
//     switch (priority.toLowerCase()) {
//       case 'high':
//         return Colors.redAccent;
//       case 'medium':
//         return Colors.orangeAccent;
//       case 'low':
//       default:
//         return Colors.green;
//     }
//   }
// }
// import 'dart:ui' as ui;
// import 'package:easy_localization/easy_localization.dart';
// import 'package:eslam_s_application/core/utils/app_export.dart';
// import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
// import 'package:flutter/material.dart';
// import 'done_button.dart';

// class ReminderCard extends StatelessWidget {
//   final ReminderModel reminder;
//   final VoidCallback onDelete;
//   final ValueChanged<bool?> onToggleCompletion;

//   const ReminderCard({
//     Key? key,
//     required this.reminder,
//     required this.onDelete,
//     required this.onToggleCompletion,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = AppColors.getTextColor(context);
//     final priorityColor = _priorityColor(reminder.priority);

//     final bgGradient = isDark
//         ? [
//             priorityColor.withOpacity(0.15),
//             Colors.black.withOpacity(0.5),
//           ]
//         : [
//             priorityColor.withOpacity(0.08),
//             Colors.white.withOpacity(0.9),
//           ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: bgGradient,
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: priorityColor.withOpacity(0.2),
//                 width: 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: priorityColor.withOpacity(0.15),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Material(
//               type: MaterialType.transparency,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(20),
//                 splashColor: priorityColor.withOpacity(0.12),
//                 highlightColor: priorityColor.withOpacity(0.06),
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Priority Line
//                       Container(
//                         width: 5,
//                         height: 95.h,
//                         decoration: BoxDecoration(
//                           color: priorityColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       const SizedBox(width: 12),

//                       // Done Button
//                       DoneButton(
//                         isCompleted: reminder.isCompleted,
//                         color: priorityColor,
//                         onToggle: (value) => onToggleCompletion(value),
//                       ),
//                       const SizedBox(width: 12),

//                       // Text Content
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               reminder.title,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: reminder.isCompleted
//                                     ? priorityColor.withOpacity(0.7)
//                                     : textColor,
//                                 decoration: reminder.isCompleted
//                                     ? TextDecoration.lineThrough
//                                     : TextDecoration.none,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             if (reminder.description.isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 6, bottom: 8),
//                                 child: Text(
//                                   reminder.description,
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: textColor.withOpacity(0.75),
//                                     height: 1.3,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),

//                             // Info Chips
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 6,
//                               children: [
//                                 if (reminder.location?.isNotEmpty == true)
//                                   _infoChip(
//                                     icon: Icons.location_on_outlined,
//                                     text: reminder.location!,
//                                     bgColor: _chipColor(context),
//                                     iconColor: Colors.tealAccent.shade400,
//                                   ),
//                                 if (reminder.dateTime != null)
//                                   _infoChip(
//                                     icon: Icons.schedule_outlined,
//                                     text: DateFormat('MMM d, yyyy • hh:mm a')
//                                         .format(reminder.dateTime!),
//                                     bgColor: _chipColor(context),
//                                     iconColor: AppColors.blueColor,
//                                   ),
//                                 _infoChip(
//                                   icon: Icons.flag_rounded,
//                                   text: reminder.priority,
//                                   bgColor: _chipColor(context),
//                                   iconColor: priorityColor,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(width: 8),

//                       // Action Buttons
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           _circleIconButton(
//                             icon: Icons.edit_rounded,
//                             color: AppColors.blueColor,
//                             onTap: () {
//                               // Handle edit
//                             },
//                           ),
//                           const SizedBox(height: 6),
//                           _circleIconButton(
//                             icon: Icons.delete_rounded,
//                             color: AppColors.redColor,
//                             onTap: onDelete,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoChip({
//     required IconData icon,
//     required String text,
//     required Color bgColor,
//     required Color iconColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: iconColor.withOpacity(0.1), width: 0.6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 15, color: iconColor),
//           const SizedBox(width: 5),
//           Flexible(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: iconColor,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _circleIconButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color.withOpacity(0.12),
//         ),
//         child: Icon(icon, size: 18, color: color),
//       ),
//     );
//   }

//   Color _chipColor(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);
//   }

//   Color _priorityColor(String priority) {
//     switch (priority.toLowerCase()) {
//       case 'high':
//         return Colors.redAccent.shade200;
//       case 'medium':
//         return Colors.orangeAccent.shade200;
//       case 'low':
//       default:
//         return Colors.greenAccent.shade400;
//     }
//   }
// }
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:flutter/material.dart';
import 'done_button.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleCompletion;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.onDelete,
    required this.onToggleCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextColor(context);
    final priorityColor = _priorityColor(reminder.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  priorityColor.withOpacity(0.14),
                  isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.blueGrey.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: priorityColor.withOpacity(0.35),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: priorityColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoneButton(
                    isCompleted: reminder.isCompleted,
                    color: priorityColor,
                    onToggle: onToggleCompletion,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: reminder.isCompleted
                                ? textColor.withOpacity(0.45)
                                : textColor,
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (reminder.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 10),
                            child: Text(
                              reminder.description,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.3,
                                color: textColor.withOpacity(0.7),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (reminder.dateTime != null)
                              _infoChip(
                                icon: Icons.access_time_rounded,
                                text: DateFormat('MMM d, yyyy • hh:mm a')
                                    .format(reminder.dateTime!),
                                color: AppColors.blueColor,
                                isDark: isDark,
                              ),
                            if (reminder.location?.isNotEmpty ?? false)
                              _infoChip(
                                icon: Icons.location_on_outlined,
                                text: reminder.location!,
                                color: Colors.tealAccent.shade700,
                                isDark: isDark,
                              ),
                            _infoChip(
                              icon: Icons.flag_rounded,
                              text: reminder.priority,
                              color: priorityColor,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                        icon: Icons.edit_rounded,
                        color: AppColors.blueColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      _actionButton(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.redColor,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(isDark ? 0.1 : 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.25),
              color.withOpacity(0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent.shade200;
      case 'medium':
        return Colors.orangeAccent.shade200;
      case 'low':
      default:
        return AppColors.blueColor.withOpacity(0.85);
    }
  }
}
