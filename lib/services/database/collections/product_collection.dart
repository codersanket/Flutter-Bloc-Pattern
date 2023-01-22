import 'package:isar/isar.dart';
part 'product_collection.g.dart';

@Collection()
class ProductCollection {
  Id? id;
  String? title;
  double? price;
  String? category;
  String? description;
  String? image;
}
