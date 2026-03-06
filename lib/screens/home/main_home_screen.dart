import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:clone_tour_guide/screens/poi/poi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clone_tour_guide/screens/home/widgets/list_fragment.dart';
import 'package:clone_tour_guide/screens/floor/map_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';

class MainHomeScreen extends HookConsumerWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(1);

    // Placeholder screens for the fragments
    final fragments = const [ListFragment(), PoiScreen(), MapScreen()];

    return Scaffold(
      body: SafeArea(
        // To avoid redrawing completely on switch, could use an IndexedStack.
        // For now, simpler implementation.
        child: fragments[currentIndex.value],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: context.colorScheme.primary,
        unselectedItemColor: context.colorScheme.inverseSurface,
        selectedItemColor: context.colorScheme.onPrimary,
        selectedIconTheme: IconThemeData(color: context.colorScheme.onPrimary),
        unselectedIconTheme: IconThemeData(
          color: context.colorScheme.inverseSurface,
        ),
        currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: AppString.tabList.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded), // Keypad icon near enough
            label: AppString.tabKeypad.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: AppString.tabMap.tr(),
          ),
        ],
      ),
    );
  }
}
