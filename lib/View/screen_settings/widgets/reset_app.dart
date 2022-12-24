import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/settings/settings_bloc.dart';
import 'package:muiziq_app/View/screen_splash/screen_splash.dart';
import 'package:muiziq_app/constants/constants.dart';

resetApp(context) {
  return ElevatedButton(
    onPressed: () {
      resetAppAlertDialog(context);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
    ),
    child: const Text('Reset App'),
  );
}

resetAppAlertDialog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: bgPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            'Are you sure!!',
            style: TextStyle(color: Colors.red),
          ),
        ),
        content: const SizedBox(
          height: 65,
          child: Center(
            child: Text(
              'Resetting the app will remove all your playlist and favorite songs.',
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<SettingsBloc>(context).add(ResetApplication());
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ScreenSplash(),
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reset App'),
            ),
          ),
        ],
      );
    },
  );
}
