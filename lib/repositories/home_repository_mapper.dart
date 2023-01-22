part of 'home_repository.dart';

extension on List<String> {
  List<ProductModel> get toModel =>
      map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
}
