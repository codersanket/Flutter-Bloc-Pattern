import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_box/features/cart/widget/cart_icon.dart';
import 'package:infinity_box/model/product_model.dart';
import 'package:infinity_box/shared/helpers/extensions.dart';

import '../cart/bloc/cart_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(this.productModel, {super.key});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.title),
        actions: const [CartIcon()],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.5,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Image.network(productModel.image),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      productModel.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      '₹ ${productModel.price} only',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Description:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      productModel.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    Text(
                      '₹${productModel.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<CartBloc, List<ProductModel>>(
                  builder: (context, state) {
                    return MaterialButton(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      // ignore: prefer-extracting-callbacks
                      onPressed: () {
                        final bloc = context.read<CartBloc>();
                        state.isPresentInList(productModel.id)
                            ? bloc.add(CartEvent.delete(productModel.id))
                            : bloc.add(CartEvent.addToCart(productModel));
                      },
                      child: state.isPresentInList(productModel.id)
                          ? const Text(
                              'Remove from Cart',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
