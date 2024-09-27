import 'package:bloc101/api/login_api.dart';
import 'package:bloc101/api/notes_api.dart';
import 'package:bloc101/blocs/app_bloc.dart';
import 'package:bloc101/blocs/app_state.dart';
import 'package:bloc101/model/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });
  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.foobar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail, acceptedPassword;
  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '';

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return const LoginHandle.foobar();
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
      'Initial state of the bloc should be AppState.empty()',
      build: () => AppBloc(
            loginApiProtocol: const DummyLoginApi.empty(),
            notesApiProtocol: const DummyNotesApi.empty(),
          ),
      verify: (appState) => expect(appState.state, AppState.empty()));
}
