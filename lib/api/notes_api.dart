import 'package:bloc101/model/models.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.foobar() ? mockNotes : null,
      );
}
