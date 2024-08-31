import 'dart:convert';
import 'dart:io';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

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

List<String> names = ['foo', 'bar'];

void testIt() {
  final baz = names[1];
}

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

@immutable
class Person {
  final String name;
  final int age;
  const Person({required this.name, required this.age});
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;
  FetchResult({required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache), persons = $persons';
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonURL, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result =
              FetchResult(persons: cachedPersons, isRetrievedFromCache: true);
          emit(result);
        } else {
          final persons = await getPersons(url.urlString);
          _cache[url] = persons;
          final result =
              FetchResult(persons: persons, isRetrievedFromCache: false);
          emit(result);
        }
      },
    );
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
        home: BlocProvider(
          create: (_) => PersonBloc(),
          child: MyHomePage(
              // title: 'Demo Bloc',
              ),
        ));
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(LoadPersonAction(url: PersonURL.persons1));
                  },
                  child: Text('Load Json1')),
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(LoadPersonAction(url: PersonURL.persons1));
                  },
                  child: Text('Load Json2'))
            ],
          ),
          BlocBuilder<PersonBloc, FetchResult?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder: (context, state) {
              final persons = state?.persons;
              state?.log();
              if (persons == null) {
                return SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(persons[index]!.name),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
