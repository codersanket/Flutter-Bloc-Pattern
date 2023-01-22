import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/features/home/bloc/home_bloc.dart';
import 'package:infinity_box/features/home/ui/product_view.dart';
import 'package:infinity_box/model/product_model.dart';

class ProductList extends StatefulWidget {
  const ProductList(
    this.model, {
    required this.isLoading,
    super.key,
  });
  final List<ProductModel> model;
  final bool isLoading;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() => _handleLoadMore(context));
    super.initState();
  }

  void _handleLoadMore(BuildContext context) {
    final currentPosition = _scrollController.offset;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (currentPosition > maxExtent - 5) {
      context.read<HomeBloc>().add(const HomeEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: widget.isLoading
            // ignore: avoid-nested-conditional-expressions
            ? widget.model.length.isEven
                ? widget.model.length + 2
                : widget.model.length + 3
            : widget.model.length,
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, index) {
          if (index > widget.model.length - 1) {
            return const Center(
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          }

          final product = widget.model[index];

          return ProductView(product);
        },
      ),
    );
  }
}
