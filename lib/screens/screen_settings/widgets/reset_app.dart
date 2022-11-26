import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';

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
                resetApplication(context);
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
