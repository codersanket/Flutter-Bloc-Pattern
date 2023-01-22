import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/app/app_route.gr.dart';
import 'package:infinity_box/features/cart/bloc/cart_bloc.dart';
import 'package:infinity_box/model/product_model.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(const CartRoute()),
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
            BlocBuilder<CartBloc, List<ProductModel>>(builder: (_, state) {
              if (state.isEmpty) return const SizedBox();

              return Positioned(
                top: 3,
                left: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      state.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
