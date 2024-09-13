import 'package:bloc/bloc.dart';
import 'package:bloc101/api/login_api.dart';
import 'package:bloc101/api/notes_api.dart';
import 'package:bloc101/blocs/action.dart';
import 'package:bloc101/blocs/app_state.dart';
import 'package:bloc101/model/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApiProtocol;
  final NotesApiProtocol notesApiProtocol;

  AppBloc({required this.loginApiProtocol, required this.notesApiProtocol})
      : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        emit(const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null));

        final loginHandle = await loginApiProtocol.login(
            email: event.email, password: event.password);

        emit(AppState(
            isLoading: false,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null));
      },
    );
    on<LoadNoteAction>(
      (event, emit) {
        emit(AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null));
      },
    );

    final loginHandle = state.loginHandle;
    if (loginHandle != const LoginHandle.foobar()) {
      emit(AppState(
          isLoading: false,
          loginErrors: LoginErrors.invalidHandle,
          loginHandle: loginHandle,
          fetchedNotes: null));
      return;
    }
    final notes = await notesApiProtocol.getNotes(loginHandle: loginHandle!);
  }
}
