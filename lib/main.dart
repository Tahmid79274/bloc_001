import 'package:bloc101/api/login_api.dart';
import 'package:bloc101/api/notes_api.dart';
import 'package:bloc101/blocs/action.dart';
import 'package:bloc101/blocs/app_bloc.dart';
import 'package:bloc101/blocs/app_state.dart';
import 'package:bloc101/dialogs/generic_dialog.dart';
import 'package:bloc101/dialogs/loading_screen.dart';
import 'package:bloc101/model/models.dart';
import 'package:bloc101/strings.dart';
import 'package:bloc101/views/iterable_list_view.dart';
import 'package:bloc101/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
          // title: 'Demo Bloc',
          ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApiProtocol: LoginApi(),
        notesApiProtocol: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  LoginAction(email: email, password: password);
                },
              );
            } else {
              return notes.toListView();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final loginErrors = appState.loginErrors;
            if (loginErrors != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.foobar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNoteAction());
            }
          },
        ),
      ),
    );
  }
}
