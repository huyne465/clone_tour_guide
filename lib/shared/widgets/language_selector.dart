import 'package:clone_tour_guide/providers/floor/floor_provider.dart';
import 'package:clone_tour_guide/providers/poi/poi_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (Locale locale) async {
        await context.setLocale(locale);
        // Refresh API data for the new language
        ref.invalidate(floorsViewModelProvider);
        ref.invalidate(poisViewModelProvider);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('vi'),
          child: Row(
            children: [
              Text('🇻🇳', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('Tiếng Việt'),
              if (context.locale.languageCode == 'vi') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              Text('🇬🇧', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('English'),
              if (context.locale.languageCode == 'en') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ja'),
          child: Row(
            children: [
              Text('🇯🇵', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('日本語'),
              if (context.locale.languageCode == 'ja') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('zh'),
          child: Row(
            children: [
              Text('🇨🇳', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('中文'),
              if (context.locale.languageCode == 'zh') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
