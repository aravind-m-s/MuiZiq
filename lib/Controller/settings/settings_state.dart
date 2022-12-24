part of 'settings_bloc.dart';

class SettingsState {
  final bool status;
  String? version;
  SettingsState({this.status = false, this.version});
}

class SettingsInitial extends SettingsState {
  SettingsInitial({super.status});
}
