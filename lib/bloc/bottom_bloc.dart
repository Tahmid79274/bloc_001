import 'package:bloc101/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
