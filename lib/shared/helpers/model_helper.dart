import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinity_box/app/app_route.gr.dart';

class ModalHelper {
  final AppRouter _appRouter;
  bool isLoaderVisible = false;
  BuildContext get _rootContext => _appRouter.navigatorKey.currentContext!;
  ModalHelper(this._appRouter);

  void showLoadingWidget() {
    isLoaderVisible = true;

    // ignore: prefer-async-await, inference_failure_on_function_invocation
    unawaited(showDialog(
      context: _rootContext,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    ).then((value) => isLoaderVisible = false));
  }

  ScaffoldMessengerState showSnackBar(String title) {
    return ScaffoldMessenger.of(_rootContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(title),
      ));
  }

  void removeLoader() {
    if (!isLoaderVisible) return;
    Navigator.pop(_rootContext);
  }
}
