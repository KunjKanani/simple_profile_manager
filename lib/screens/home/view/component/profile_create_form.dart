import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location_profiles/lib.dart';
import 'package:provider/provider.dart';

class ProfileCreateForm extends StatelessWidget {
  const ProfileCreateForm({super.key, required this.homeProvider});

  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: const Center(
        child: Text('Create Profile'),
      ),
      insetPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 400,
        child: Form(
          key: homeProvider.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: homeProvider.nameController,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  cursorHeight: 20,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: homeProvider.latitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    CoordinatesInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a latitude';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid latitude';
                    }

                    if (RegExp(r'^-?([0-9]{1,2}|1[0-7][0-9]|180)(\.[0-9]{1,10})?$')
                            .hasMatch(value) ==
                        false) {
                      return 'Please enter a valid latitude';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: homeProvider.longitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    CoordinatesInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a longitude';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid longitude';
                    }

                    if (RegExp(r'^-?([0-9]{1,2}|1[0-7][0-9]|180)(\.[0-9]{1,10})?$')
                            .hasMatch(value) ==
                        false) {
                      return 'Please enter a valid longitude';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 58,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return DropdownButton<String>(
                        iconSize: 0,
                        items: const [
                          DropdownMenuItem(
                            value: 'light',
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: 'dark',
                            child: Text('Dark'),
                          ),
                        ],
                        value: homeProvider.themeMode,
                        underline: Container(),
                        onChanged: (value) {
                          homeProvider.themeMode = value ?? 'light';
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 58,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return DropdownButton<String>(
                        iconSize: 0,
                        items: const [
                          DropdownMenuItem(
                            value: 'small',
                            child: Text('Small'),
                          ),
                          DropdownMenuItem(
                            value: 'normal',
                            child: Text('Normal'),
                          ),
                          DropdownMenuItem(
                            value: 'large',
                            child: Text('Large'),
                          ),
                        ],
                        value: homeProvider.textScaleFactor,
                        underline: Container(),
                        onChanged: (value) {
                          homeProvider.textScaleFactor = value ?? 'normal';
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        homeProvider.createProfile();
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CoordinatesInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // REMOVE CHARACTERS OTHER THAN NUMBERS, DECIMAL POINT, AND NEGATIVE SIGN

    if (newValue.text.contains(RegExp(r'[^0-9\.\-]'))) {
      return oldValue;
    }

    return newValue;
  }
}
