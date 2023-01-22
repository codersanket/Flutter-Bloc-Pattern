part of 'cart_repository.dart';

extension on List<ProductCollection> {
  List<ProductModel> get toModel => map((e) {
        return ProductModel(
          category: e.category ?? '',
          description: e.description ?? '',
          id: e.id ?? 0,
          image: e.image ?? '',
          price: e.price ?? 0.0,
          title: e.title ?? '',
        );
      }).toList();
}

extension on ProductModel {
  ProductCollection get toCollection => ProductCollection()
    ..id = id
    ..title = title
    ..category = category
    ..image = image
    ..price = price
    ..description = description;
}
