import 'index.dart';

class ProductDatabase extends DataBase<ProductCollection> {
  ProductDatabase(super.isar);

  Future<List<ProductCollection>> getCart() async {
    return getAll();
  }

  Future<int> addItem(ProductCollection collection) async {
    return add(collection);
  }

  Future<bool> removeItem(int id) async {
    return delete(id);
  }
}
