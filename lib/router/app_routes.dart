import 'package:clone_tour_guide/router/routes_name.dart';
import 'package:clone_tour_guide/screens/detail_poi/audio_detail_screen.dart';
import 'package:clone_tour_guide/screens/home/main_home_screen.dart';
import 'package:clone_tour_guide/screens/intro/intro_screen.dart';
import 'package:clone_tour_guide/screens/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    RoutesName.welcome: (context) => const WelcomeScreen(),
    RoutesName.intro: (context) => const IntroScreen(),
    RoutesName.main: (context) => const MainHomeScreen(),
    RoutesName.audioDetail: (context) => const AudioDetailScreen(),
  };
}
