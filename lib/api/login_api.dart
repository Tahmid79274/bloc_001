import 'package:bloc101/model/models.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({required String email, required String password});
}

@immutable
class LoginApi implements LoginApiProtocol {
  const LoginApi._sharedInstance();

  static const LoginApi _shared = LoginApi._sharedInstance();

  factory LoginApi() => _shared;
  
  @override
  Future<LoginHandle?> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
