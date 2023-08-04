import 'package:flutter/material.dart';
import 'package:location_profiles/lib.dart';
import 'package:location_profiles/routes/app_pages.dart';
import 'package:provider/provider.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<ThemeChanger>(
          create: (context) => ThemeChanger(darkTheme),
        ),
      ],
      child: Consumer<ThemeChanger>(
        builder: (context, themeChanger, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            onGenerateRoute: onGenerateRoutes,
            theme: themeChanger.getTheme,
            initialRoute: AppPages.initialRoute,
          );
        },
      ),
    );
  }
}
