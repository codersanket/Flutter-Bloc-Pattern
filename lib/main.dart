import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_bloc_observer.dart';
import 'package:infinity_box/app/app_bootstrapped.dart';
import 'package:infinity_box/app/app_route.gr.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  AppBootStrapper.instance.initialize();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<bool>(
        stream: AppBootStrapper.instance.isInitialized,
        builder: (context, snapshot) {
          final isInitialized = snapshot.data ?? false;
          if (isInitialized) {
            return BlocProvider<AppBloc>(
              create: (_) => get()..add(const AppEvent.initialize()),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorSchemeSeed: const Color(0xff6750a4),
                  useMaterial3: true,
                ),
                routerDelegate: get<AppRouter>().delegate(),
                routeInformationParser: get<AppRouter>().defaultRouteParser(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
