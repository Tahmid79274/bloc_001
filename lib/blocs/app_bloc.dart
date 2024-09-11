import 'package:bloc/bloc.dart';
import 'package:bloc101/api/login_api.dart';
import 'package:bloc101/api/notes_api.dart';
import 'package:bloc101/blocs/action.dart';
import 'package:bloc101/blocs/app_state.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApiProtocol;
  final NotesApiProtocol notesApiProtocol;

  AppBloc({required this.loginApiProtocol, required this.notesApiProtocol})
      : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) {},
    );
  }
}
