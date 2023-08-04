import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_profiles/lib.dart';
import 'package:location_profiles/screens/home/model/profile.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.onActivateProfile,
    required this.profile,
    required this.isActivated,
  });

  final VoidCallback onActivateProfile;
  final ProfileModel? profile;
  final bool isActivated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: profileInitialColors[
                    Random().nextInt(profileInitialColors.length)],
                foregroundColor: Colors.white,
                radius: 28.0,
                child: Text(
                  (profile?.name?.substring(0, 1).toUpperCase()) ?? '',
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Lat: ${profile?.lat} | Lng: ${profile?.long}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: !isActivated ? onActivateProfile : null,
                style: TextButton.styleFrom(
                  backgroundColor: isActivated ? Colors.green : null,
                  minimumSize: const Size(100, 40),
                  maximumSize: const Size(100, 40),
                ),
                child: Text(
                  isActivated ? 'Activated' : 'Activate',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // divider
        Divider(
          height: 1.0,
          thickness: 1.0,
          color: Colors.grey[900],
        ),
      ],
    );
  }
}
