import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_bootstrapped.dart';
import 'package:infinity_box/features/cart/bloc/cart_bloc.dart';

class HomeWrapperScreen extends StatelessWidget {
  const HomeWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => get()..add(const CartEvent.initialize()),
      child: const AutoRouter(),
    );
  }
}
