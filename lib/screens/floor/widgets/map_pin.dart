import 'package:clone_tour_guide/constants/theme/app_size_config.dart';
import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:clone_tour_guide/router/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapPin extends StatelessWidget {
  const MapPin({super.key, required this.context, required this.code});

  final BuildContext context;
  final String code;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(RoutesName.audioDetail, arguments: code);
      },
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          code,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppConstants.fontSizeLabelSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
