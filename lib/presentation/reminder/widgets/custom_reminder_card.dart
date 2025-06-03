
import 'package:flutter/material.dart';
import 'package:eslam_s_application/core/app_export.dart';

class RadioCard extends StatelessWidget {
  final String title;
  final bool value;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const RadioCard({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: .6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: value ? const Color.fromARGB(255, 243, 250, 250) : Colors.white,
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.h),
        leading: IconButton(
          icon: Icon(
            value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: value ? AppColors.blueColor : Colors.grey,
          ),
          onPressed: onChanged,
        ),
        title: Text(
          title,
          
          style: TextStyle(
            color: value ? AppColors.blueColor : Colors.black87,
            fontSize: 15.h
          ),
        ),
        onTap: onChanged,
        trailing: IconButton(
          onPressed:  onDelete,
        icon: Icon(Icons.delete,color: const Color.fromARGB(255, 213, 14, 0),)),
      ),
    );
  }
}
