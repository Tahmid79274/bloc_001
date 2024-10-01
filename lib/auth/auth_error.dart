import 'package:flutter/foundation.dart';

const Map<String, AuthError> authErrorMapping = {};

@immutable
abstract class AuthError {
  final String dialogTitle, dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });
}
