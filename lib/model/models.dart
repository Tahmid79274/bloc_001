import 'package:flutter/foundation.dart';

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.foobar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) {
    return token == other.token;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle= $token';
}

enum LoginErrors { invalidHandle }

@immutable
class Note {
  final String title;

  const Note({required this.title});

  @override
  String toString() => 'Note (title = $title)';
}

final mockNotes = Iterable.generate(3, (i) => Note(title: 'Note $i'));
