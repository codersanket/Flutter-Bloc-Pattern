import 'package:infinity_box/model/index.dart';
import 'package:infinity_box/services/index.dart';

part './cart_reposiotry_mapper.dart';

class CartRepository {
  final ProductDatabase _database;

  CartRepository(this._database);

  Future<List<ProductModel>> getItemsFromCart() async {
    final productCollection = await _database.getCart();

    return productCollection.toModel;
  }

  Future<bool> deleteItemFromCart(int id) async {
    return _database.delete(id);
  }

  Future<int> addItemToCart(ProductModel model) async {
    return _database.addItem(model.toCollection);
  }
}
