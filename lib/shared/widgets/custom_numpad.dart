import 'package:clone_tour_guide/constants/theme/app_size_config.dart';
import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberTapped;
  final VoidCallback onClearTapped;
  final VoidCallback onOkTapped;

  const CustomNumpad({
    super.key,
    required this.onNumberTapped,
    required this.onClearTapped,
    required this.onOkTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingSM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // shrink-wrap
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton(context, '1'),
              _buildNumpadButton(context, '2'),
              _buildNumpadButton(context, '3'),
            ],
          ),
          context.gapMD, // SizedBox(height: 16)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton(context, '4'),
              _buildNumpadButton(context, '5'),
              _buildNumpadButton(context, '6'),
            ],
          ),
          context.gapMD, // SizedBox(height: 16)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton(context, '7'),
              _buildNumpadButton(context, '8'),
              _buildNumpadButton(context, '9'),
            ],
          ),
          context.gapMD, // SizedBox(height: 16)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(child: SizedBox()), // Empty space
              _buildNumpadButton(context, '0'),
              Expanded(
                child: IconButton(
                  onPressed: onClearTapped,
                  icon: const Icon(Icons.backspace_outlined),
                  color: context.colorScheme.onSurface,
                  iconSize: 28.w,
                ),
              ),
            ],
          ),
          context.gapLG, // SizedBox(height: 24)
          // OK Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onOkTapped,
              child: Text(
                'Ok',
                style: TextStyle(fontSize: AppConstants.fontSizeTitleMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadButton(BuildContext context, String number) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingSM),
        child: SizedBox(
          height: 64.h,
          child: FilledButton.tonal(
            onPressed: () => onNumberTapped(number),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              foregroundColor: context.colorScheme.onSurface,
              shape: RoundedRectangleBorder(borderRadius: context.radiusMD),
              elevation: 0,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: AppConstants.fontSizeTitleMedium,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
