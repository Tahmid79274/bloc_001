import 'package:bloc101/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
