import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilledButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? labelColor;
  final String label;
  final Icon icon;
  final VoidCallback onPressed;
  const CustomFilledButton({
    super.key,
    this.backgroundColor,
    this.labelColor,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      // ()
      //  {
      //   Navigator.of(
      //     context,
      //   ).pushReplacementNamed(RoutesName.main);
      // },
      icon: icon,
      label: Text(
        // AppString.startTour.tr(),
        label,
        style: TextStyle(color: labelColor ?? context.colorScheme.onPrimary),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? context.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
    );
  }
}
