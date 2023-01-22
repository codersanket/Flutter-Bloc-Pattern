import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/features/home/bloc/home_bloc.dart';

class Categories extends StatelessWidget {
  const Categories(this.state, {super.key});

  final HomeStateView state;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // ignore: prefer-extracting-callbacks
        children: List.generate(state.categories.length, (index) {
          final query = state.categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilterChip(
              selected: state.query == query,
              label: Text(
                query,
              ),
              onSelected: (bool value) =>
                  context.read<HomeBloc>().add(HomeEvent.sort(query)),
            ),
          );
        }),
      ),
    );
  }
}
