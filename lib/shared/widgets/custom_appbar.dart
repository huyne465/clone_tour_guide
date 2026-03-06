import 'package:clone_tour_guide/constants/theme/app_size_config.dart';
import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.primary,
      title: Text(
        title,
        style: TextStyle(
          color: context.colorScheme.onPrimary,
          fontSize: AppConstants.fontSizeTitleLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      actionsPadding: context.paddingSM,
    );
  }
}
