import 'dart:convert';
import 'dart:io';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

// const names = ['foo', 'bar', 'baz'];

// extension RandomElement<T> on Iterable<T> {
//   T getRandomElement() => elementAt(math.Random().nextInt(length));
// }

// class NamesCubit extends Cubit<String?> {
//   NamesCubit() : super(null);

//   void pickRandomName() => emit(names.getRandomElement());
// }

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonURL url;

  LoadPersonAction({required this.url}) : super();
}

enum PersonURL { persons1, persons2 }

extension UrlString on PersonURL {
  String get urlString {
    switch (this) {
      case PersonURL.persons1:
        return 'http://127.0.0.1:5500/api/person1.json';
      case PersonURL.persons2:
        return 'http://127.0.0.1:5500/api/person2.json';
    }
  }
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
        home: MyHomePage(
            // title: 'Demo Bloc',
            ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final Bloc myBloc;
    return Container();
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late final NamesCubit namesCubit;

//   @override
//   void initState() {
//     namesCubit = NamesCubit();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     namesCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Home Page'),
//         ),
//         body: StreamBuilder<String?>(
//           stream: namesCubit.stream,
//           builder: (context, snapshot) {
//             final button = TextButton(
//               child: Text('click on Random Button'),
//               onPressed: () {
//                 namesCubit.pickRandomName();
//               },
//             );
//             switch (snapshot.connectionState) {
//               case ConnectionState.none:
//                 return Column(
//                   children: [Text('none'), button],
//                 );
//               case ConnectionState.waiting:
//                 return Column(
//                   children: [Text('waiting'), button],
//                 );
//               case ConnectionState.active:
//                 return Column(
//                   children: [Text(snapshot.data ?? 'active'), button],
//                 );
//               case ConnectionState.done:
//                 return Container(
//                   color: Colors.red,
//                   width: 100,
//                   height: 100,
//                 );
//             }
//           },
//         ));
//   }
// }
