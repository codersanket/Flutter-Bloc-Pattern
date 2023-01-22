import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_bootstrapped.dart';
import 'package:infinity_box/features/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatelessWidget with AutoRouteWrapper {
  const AuthScreen({super.key});
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => get(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) => Scaffold(
        body: LoginView(),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});

  late String username = '', passWord = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Username'),
              ),
              onChanged: (value) => username = value,
            ),
            const SizedBox(
              height: 18,
            ),
            TextFormField(
              onChanged: (value) => passWord = value,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(AuthEvent.login(username, passWord)),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
