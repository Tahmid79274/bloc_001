import 'package:bloc101/model/models.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NotesApiProtocol {
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.foobar() ? mockNotes : null,
      );
}
