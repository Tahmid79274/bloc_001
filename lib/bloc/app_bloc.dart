import 'dart:io';

import 'package:bloc101/auth/auth_error.dart';
import 'package:bloc101/bloc/app_event.dart';
import 'package:bloc101/bloc/app_state.dart';
import 'package:bloc101/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLogout(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>(
      (event, emit) async {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventLogIn>(
      (event, emit) async {
        emit(
          const AppStateLogout(
            isLoading: true,
          ),
        );
        try {
          final email = event.email;
          final password = event.password;
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLogout(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(const AppStateLogout(isLoading: false));
      },
    );
    on<AppEventRegister>(
      (event, emit) async {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credential.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLogout(
              isLoading: false,
            ),
          );
        } else {
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        }
      },
    );
    on<AppEventLogOut>(
      (event, emit) async {
        emit(
          const AppStateLogout(
            isLoading: true,
          ),
        );
        await FirebaseAuth.instance.signOut();
        emit(
          const AppStateLogout(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser!;
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        try {
          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();

          for (final item in folder.items) {
            await item.delete().catchError((_) {});
          }
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});
          await user.delete();
          await FirebaseAuth.instance.signOut();
          emit(
            const AppStateLogout(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          emit(
            const AppStateLogout(
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        if (user == null) {
          emit(
            const AppStateLogout(
              isLoading: false,
            ),
          );
          return;
        }
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        final file = File(event.filePathUpload);
        await uploadImage(
          file: file,
          userId: user.uid,
        );

        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
