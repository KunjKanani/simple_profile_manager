import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location_profiles/lib.dart';
import 'package:location_profiles/main.dart';
import 'package:location_profiles/screens/home/model/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  // Animation variables
  AnimationController? _animationController;
  Animation<double>? sutterOpenTween;
  Animation<double>? sutterCloseTween;

  // Profile variables
  ProfileData _profilesDataBase = ProfileData(profiles: []);
  ProfileModel? _activatedProfile;

  late SharedPreferences prefs;
  bool _isProfileLoading = false;

  // Form variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  var _themeMode = 'dark';

  var _textScaleFactor = 'normal';

  ProfileData get profilesDataBase => _profilesDataBase;

  AnimationController? get animationController => _animationController;

  bool get isProfileLoading => _isProfileLoading;

  ProfileModel? get activatedProfile => _activatedProfile;

  String get themeMode => _themeMode;

  String get textScaleFactor => _textScaleFactor;

  set textScaleFactor(String value) {
    _textScaleFactor = value;
    notifyListeners();
  }

  set themeMode(String value) {
    _themeMode = value;
    notifyListeners();
  }

  set activatedProfile(ProfileModel? value) {
    _activatedProfile = value;
    notifyListeners();
  }

  set isProfileLoading(bool value) {
    _isProfileLoading = value;
    notifyListeners();
  }

  init({
    required TickerProvider vsync,
    required double screenWidth,
  }) async {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 6000),
    );

    sutterCloseTween = Tween<double>(
      begin: 0.0,
      end: screenWidth * 0.5,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.easeOut,
        ),
      ),
    );

    sutterOpenTween = Tween<double>(
      begin: screenWidth * 0.5,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0.7,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfiles();
    });
  }

  fetchProfiles() async {
    isProfileLoading = true;

    prefs = await SharedPreferences.getInstance();

    // prefs.clear();

    final profiles = prefs.getString('profiles');

    if (profiles != null) {
      _profilesDataBase = ProfileData.fromJson(
        jsonDecode(
          profiles,
        ),
      );
    }

    isProfileLoading = false;
  }

  void createProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    startSutterAnimation();

    final profile = ProfileModel(
      name: nameController.text,
      lat: double.parse(latitudeController.text),
      long: double.parse(longitudeController.text),
      fontSize: textScaleFactor,
      theme: themeMode,
    );

    // Save to shared preferences
    _profilesDataBase.toString();

    _profilesDataBase.profiles.add(profile);

    prefs.setString('profiles', jsonEncode(_profilesDataBase.toJson()));

    nameController.clear();
    latitudeController.clear();
    longitudeController.clear();

    Navigator.of(formKey.currentContext!).pop();

    await Future.delayed(
      const Duration(milliseconds: 2000),
    );

    activatedProfile ??= profile;
    notifyListeners();
  }

  void startSutterAnimation() async {
    _animationController!.forward();

    await Future.delayed(
      const Duration(milliseconds: 6000),
    );

    _animationController!.reset();
  }

  void activateProfile(ProfileModel profile, BuildContext context) async {
    startSutterAnimation();

    await Future.delayed(
      const Duration(milliseconds: 2000),
    );

    if (!context.mounted) return;

    Provider.of<ThemeChanger>(context, listen: false).setTheme(
      profile.theme == 'dark' ? darkTheme : lightTheme,
    );

    activatedProfile = profile;

    notifyListeners();
  }
}
