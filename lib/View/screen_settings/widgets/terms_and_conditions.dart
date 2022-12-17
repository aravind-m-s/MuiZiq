import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

termsAndConditions() {
  return InkWell(
    onTap: () {},
    child: Row(
      children: const [
        Icon(
          Icons.filter_none,
          color: textColor,
        ),
        kWidth10,
        Text(
          'Terms and conditions',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    ),
  );
}
