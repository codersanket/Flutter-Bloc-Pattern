import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_box/model/product_model.dart';
import 'package:infinity_box/repositories/cart_repository.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';

part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, List<ProductModel>> {
  final CartRepository _repository;
  final ModalHelper _helper;

  CartBloc(this._repository, this._helper) : super([]) {
    on<Initialize>(_initialize);
    on<AddToCart>(_addToCart);
    on<Delete>(_deleteItem);
  }

  Future<void> _initialize(
    Initialize initialize,
    Emitter<List<ProductModel>> emit,
  ) async {
    final products = await _repository.getItemsFromCart();
    emit(products);
  }

  Future<void> _addToCart(
    AddToCart addToCart,
    Emitter<List<ProductModel>> emit,
  ) async {
    await _repository.addItemToCart(addToCart.product);
    // _helper.showSnackBar("Added Item to Cart");.

    add(const CartEvent.initialize());
  }

  Future<void> _deleteItem(
    Delete delete,
    Emitter<List<ProductModel>> emit,
  ) async {
    final val = await _repository.deleteItemFromCart(delete.id);
    if (val) {
      // _helper.showSnackBar("Removed Item from Cart");.
      add(const CartEvent.initialize());
    } else {
      _helper.showSnackBar('Something went wrong while deleting item');
    }
  }
}

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.initialize() = Initialize;
  const factory CartEvent.delete(int id) = Delete;
  const factory CartEvent.addToCart(ProductModel product) = AddToCart;
}
