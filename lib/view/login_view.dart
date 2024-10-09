import 'package:bloc101/bloc/app_bloc.dart';
import 'package:bloc101/bloc/app_event.dart';
import 'package:bloc101/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'vandad.np@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'foobarbaz'.ifDebugging);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'your email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'your password'),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context
                    .read<AppBloc>()
                    .add(AppEventLogIn(email: email, password: password));
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppEventGoToRegistration());
              },
              child: const Text('Not Registered yet?'),
            ),
          ],
        ),
      ),
    );
  }
}
