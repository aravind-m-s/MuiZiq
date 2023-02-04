import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/home/home_bloc.dart';
import 'package:muiziq_app/Controller/settings/settings_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_settings/widgets/reset_app.dart';

import 'widgets/divider.dart';
import 'widgets/mail.dart';
import 'widgets/privacy_policy.dart';
import 'widgets/terms_and_conditions.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SettingsBloc>(context).add(WhatsAppFilterInitial());

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  sendMail(),
                  kHeight10,
                  dividerWidget(),
                  kHeight10,
                  termsAndConditions(),
                  kHeight10,
                  dividerWidget(),
                  kHeight10,
                  privacyPolicy(),
                  kHeight10,
                  dividerWidget(),
                  whatsappFilter(),
                  kHeight20,
                  resetApp(context),
                ],
              ),
            ),
            kHeight30,
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return const Text(
                  'Version  -  2.0',
                  style: TextStyle(color: textColor, fontSize: 20),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  whatsappFilter() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          const Icon(Icons.message, color: textColor),
          kWidth10,
          const Text(
            'Filter Whatsapp Audios',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
          kWidth20,
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Switch(
                value: state.status,
                onChanged: (value) {
                  BlocProvider.of<SettingsBloc>(context).add(WhatsAppFilter());
                  BlocProvider.of<HomeBloc>(context).add(GetAllMusic());
                },
                activeColor: themeColor,
                inactiveThumbColor: themeColor,
              );
            },
          )
        ],
      ),
    );
  }
}
