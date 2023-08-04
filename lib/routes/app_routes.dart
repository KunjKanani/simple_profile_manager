// On generate Routes

import 'package:flutter/material.dart';
import 'package:location_profiles/lib.dart';
import 'package:location_profiles/routes/app_pages.dart';

Route onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppPages.initialRoute:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
  }
}
