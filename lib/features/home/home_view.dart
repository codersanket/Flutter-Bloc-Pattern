import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_bootstrapped.dart';
import 'package:infinity_box/app/bloc/app_bloc.dart';
import 'package:infinity_box/features/cart/widget/cart_icon.dart';
import 'package:infinity_box/features/home/bloc/home_bloc.dart';
import 'package:infinity_box/features/home/ui/categories.dart';
import 'package:infinity_box/features/home/ui/product_list.dart';

class HomeScreen extends StatelessWidget with AutoRouteWrapper {
  HomeScreen({super.key});

  final ValueNotifier<bool> _showSearchBar = ValueNotifier(false);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => get()
        ..add(
          (const HomeEvent.initialize()),
        ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: () =>
                    context.read<AppBloc>().add(const AppEvent.logOut()),
                icon: const Icon(Icons.logout),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showSearchBar,
                builder: (context, snapshot, _) {
                  return IconButton(
                    // ignore: prefer-extracting-callbacks
                    onPressed: () {
                      _showSearchBar.value = !_showSearchBar.value;

                      context.read<HomeBloc>().add(const HomeEvent.search(''));
                    },
                    icon: !snapshot
                        ? const Icon(Icons.search)
                        : const Icon(Icons.search_off),
                  );
                },
              ),
              const CartIcon(),
            ],
          ),
          body: state.map(
            (value) => ProductListView(value, _showSearchBar, _controller),
            loading: (value) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView(
    this.state,
    this._showSearch,
    this._controller, {
    super.key,
  });
  final HomeStateView state;
  final ValueNotifier<bool> _showSearch;
  final TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showSearch,
      builder: (context, snapshot, child) {
        return Column(
          children: [
            if (!snapshot) Categories(state),
            if (snapshot)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) =>
                          context.read<HomeBloc>().add(HomeEvent.search(value)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      // ignore: prefer-extracting-callbacks
                      onPressed: () {
                        _showSearch.value = false;
                        _controller.clear();
                      },
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ProductList(
                snapshot ? state.searchList : state.products,
                isLoading: state.isLoadingMore,
              ),
            ),
          ],
        );
      },
    );
  }
}
