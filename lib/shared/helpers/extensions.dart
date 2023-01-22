import 'package:infinity_box/model/product_model.dart';

extension ProductModelExtension on List<ProductModel> {
  bool isPresentInList(int id) => any((element) => element.id == id);
}
