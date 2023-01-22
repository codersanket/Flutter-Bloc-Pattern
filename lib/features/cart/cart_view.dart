import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/features/cart/bloc/cart_bloc.dart';
import 'package:infinity_box/model/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocBuilder<CartBloc, List<ProductModel>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Text(
                'Go To Home Screen to add Items in cart',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (_, i) {
                    final product = state[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: ListTile(
                          leading: Image.network(product.image),
                          title: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text('₹ ${product.price}'),
                          trailing: IconButton(
                            onPressed: () => context
                                .read<CartBloc>()
                                .add(CartEvent.delete(product.id)),
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        BlocBuilder<CartBloc, List<ProductModel>>(
                          builder: (context, state) {
                            return Text(
                              '₹${getTotalPrice(state)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double getTotalPrice(List<ProductModel> model) {
    var price = 0.0;
    for (final i in model) {
      price += i.price;
    }

    return price;
  }
}
