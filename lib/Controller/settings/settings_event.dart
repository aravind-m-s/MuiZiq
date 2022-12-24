part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class WhatsAppFilter extends SettingsEvent {}

class ResetApplication extends SettingsEvent {}

class WhatsAppFilterInitial extends SettingsEvent {}

class GetApplicationVersion extends SettingsEvent {}
