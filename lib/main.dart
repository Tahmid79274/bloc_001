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
  PersonBloc() : super(null);
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
