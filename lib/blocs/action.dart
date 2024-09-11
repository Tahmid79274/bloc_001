import 'package:flutter/foundation.dart';

@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class LoginAction implements AppAction {
  final String email, password;

  const LoginAction({required this.email, required this.password});
}

@immutable
class LoadNoteAction implements AppAction {
  const LoadNoteAction();
}
