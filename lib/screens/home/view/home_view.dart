import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:location_profiles/lib.dart';

import 'package:location_profiles/screens/home/view/component/component.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();

    _homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );

    _homeProvider.init(
      screenWidth: widget.screenWidth,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _homeProvider.animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildProfileHome(context),
        _buildSutter(),
        _buildSutterLoader(),
      ],
    );
  }

  Scaffold _buildProfileHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Profiles Manager'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ProfileCreateForm(
                homeProvider: _homeProvider,
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderProfileCard(context),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            child: Text(
              'Profiles List',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildProfileList(),
        ],
      ),
    );
  }

  AnimatedBuilder _buildSutterLoader() {
    return AnimatedBuilder(
      animation: _homeProvider.animationController!,
      builder: (context, child) {
        return _homeProvider.animationController!.value >= 0.3 &&
                _homeProvider.animationController!.value <= 0.7
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SpinKitFoldingCube(
                      color: premiumColor,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Material(
                    color: Colors.transparent,
                    child: Text(
                      'Profiles are loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  AnimatedBuilder _buildSutter() {
    return AnimatedBuilder(
      animation: _homeProvider.animationController!,
      builder: (context, child) {
        return _homeProvider.animationController!.value == 0
            ? Container()
            : Transform.scale(
                scale: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.grey[900]!,
                        width: _homeProvider.animationController!.value > 0.5
                            ? _homeProvider.sutterOpenTween!.value
                            : _homeProvider.sutterCloseTween!.value,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Expanded _buildProfileList() {
    return Expanded(
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return homeProvider.isProfileLoading
              ? SpinKitThreeBounce(
                  color: secondaryColor,
                  size: 20,
                )
              : homeProvider.profilesDataBase.profiles.isEmpty
                  ? Center(
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Lottie.asset(
                            'assets/no_profile.json',
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No Profiles Found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: homeProvider.profilesDataBase.profiles.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ProfileTile(
                          onActivateProfile: () {
                            _homeProvider.activateProfile(
                              homeProvider.profilesDataBase.profiles[index],
                              context,
                            );
                          },
                          profile:
                              homeProvider.profilesDataBase.profiles[index],
                          isActivated: homeProvider.activatedProfile ==
                              homeProvider.profilesDataBase.profiles[index],
                        );
                      },
                    );
        },
      ),
    );
  }

  Padding _buildHeaderProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassmorphicContainer(
        height: 160,
        width: double.infinity,
        blur: 40,
        border: 1,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  const Color(0xFFffffff).withOpacity(0),
                  const Color((0xFFFFFFFF)).withOpacity(0.5),
                ]
              : [
                  const Color(0xFFffffff).withOpacity(0.2),
                  const Color((0xFFFFFFFF)).withOpacity(0.2),
                ],
        ),
        borderRadius: 20,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  const Color(0xFFffffff).withOpacity(0.1),
                  const Color(0xFFFFFFFF).withOpacity(0.05),
                ]
              : [
                  const Color(0xFF000000).withOpacity(0.2),
                  const Color(0xFF000000).withOpacity(0.2),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Activated Profile',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
                thickness: 1,
              ),
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  return homeProvider.activatedProfile == null
                      ? const Text(
                          'Please create/activate a profile to get started 🚀',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _homeProvider.activatedProfile!.name ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Latitude: ${_homeProvider.activatedProfile?.lat ?? ''} || Longitude: ${_homeProvider.activatedProfile?.long ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Theme: ${_homeProvider.activatedProfile?.theme ?? 'dark'} Mode • FontSize: ${_homeProvider.activatedProfile?.fontSize ?? 'normal'}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
