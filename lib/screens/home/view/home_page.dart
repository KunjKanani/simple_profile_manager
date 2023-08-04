import 'package:flutter/material.dart';
import 'package:location_profiles/lib.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView(
      screenWidth: MediaQuery.of(context).size.width,
    );
  }
}
