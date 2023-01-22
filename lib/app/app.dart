import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_route.gr.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  List<PageRouteInfo> _getRouterDelegate(AppState state) {
    return state.map(
      initial: (_) => [
        const SplashRoute(),
      ],
      initialized: (_) => [
        const AuthRoute(),
      ],
      authenticated: (_) => [
        const HomeWrapperRoute(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AutoRouter.declarative(
          routes: (h) => _getRouterDelegate(state),
        );
      },
    );
  }
}
